import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:specs/core/error/failures.dart';
import 'package:specs/core/utils/either.dart';
import 'package:specs/features/exchange/domain/entities/currency_rate.dart';
import 'package:specs/features/exchange/domain/usecases/get_currency_rates.dart';
import 'package:specs/features/exchange/domain/usecases/get_daily_rates.dart';
import 'package:specs/features/exchange/presentation/bloc/currency_bloc.dart';
import 'package:specs/features/exchange/presentation/bloc/currency_event.dart';
import 'package:specs/features/exchange/presentation/bloc/currency_state.dart';

import 'currency_bloc_test.mocks.dart';

@GenerateMocks([GetCurrencyRates, GetDailyRates])
void main() {
  late CurrencyBloc currencyBloc;
  late MockGetCurrencyRates mockGetCurrencyRates;
  late MockGetDailyRates mockGetDailyRates;

  setUp(() {
    mockGetCurrencyRates = MockGetCurrencyRates();
    mockGetDailyRates = MockGetDailyRates();
    currencyBloc = CurrencyBloc(
      getCurrencyRates: mockGetCurrencyRates,
      getDailyRates: mockGetDailyRates,
    );
  });

  tearDown(() {
    currencyBloc.close();
  });

  group('CurrencyBloc', () {
    const tCurrencyCode = 'USD';
    const tCurrencyRates = [
      CurrencyRate(
        date: '2025-09-10',
        close: 5.4317,
        open: 5.4197,
        high: 5.4429,
        low: 5.4128,
      ),
    ];
    const tDailyRates = [
      CurrencyRate(
        date: '2025-09-10',
        close: 5.4317,
        open: 5.4197,
        high: 5.4429,
        low: 5.4128,
        closeDiff: 0.12,
      ),
      CurrencyRate(
        date: '2025-09-09',
        close: 5.4197,
        open: 5.4050,
        high: 5.4250,
        low: 5.4000,
        closeDiff: 0.0147,
      ),
    ];

    test('initial state should be CurrencyInitial', () {
      expect(currencyBloc.state, equals(const CurrencyInitial()));
    });

    group('LoadCurrencyRates', () {
      blocTest<CurrencyBloc, CurrencyState>(
        'should emit [CurrencyLoading, CurrencyLoaded] when data is gotten successfully',
        build: () {
          when(mockGetCurrencyRates(any))
              .thenAnswer((_) async => const Right(tCurrencyRates));
          return currencyBloc;
        },
        act: (bloc) => bloc.add(const LoadCurrencyRates(currencyCode: tCurrencyCode)),
        expect: () => [
          const CurrencyLoading(),
          const CurrencyLoaded(tCurrencyRates),
        ],
        verify: (_) {
          verify(mockGetCurrencyRates(const GetCurrencyRatesParams(currencyCode: tCurrencyCode)));
        },
      );

      blocTest<CurrencyBloc, CurrencyState>(
        'should emit [CurrencyLoading, CurrencyError] when getting data fails with ServerFailure',
        build: () {
          when(mockGetCurrencyRates(any))
              .thenAnswer((_) async => const Left(ServerFailure('Server error')));
          return currencyBloc;
        },
        act: (bloc) => bloc.add(const LoadCurrencyRates(currencyCode: tCurrencyCode)),
        expect: () => [
          const CurrencyLoading(),
          const CurrencyError('Server error. Please try again later.'),
        ],
      );

      blocTest<CurrencyBloc, CurrencyState>(
        'should emit [CurrencyLoading, CurrencyError] when getting data fails with NetworkFailure',
        build: () {
          when(mockGetCurrencyRates(any))
              .thenAnswer((_) async => const Left(NetworkFailure('Network error')));
          return currencyBloc;
        },
        act: (bloc) => bloc.add(const LoadCurrencyRates(currencyCode: tCurrencyCode)),
        expect: () => [
          const CurrencyLoading(),
          const CurrencyError('Network error. Please check your connection.'),
        ],
      );
    });

    group('LoadDailyRates', () {
      blocTest<CurrencyBloc, CurrencyState>(
        'should emit [DailyRatesLoading, DailyRatesLoaded] when data is gotten successfully',
        build: () {
          when(mockGetDailyRates(any))
              .thenAnswer((_) async => const Right(tDailyRates));
          return currencyBloc;
        },
        act: (bloc) => bloc.add(const LoadDailyRates(currencyCode: tCurrencyCode)),
        expect: () => [
          const DailyRatesLoading(),
          const DailyRatesLoaded(tDailyRates),
        ],
        verify: (_) {
          verify(mockGetDailyRates(const GetDailyRatesParams(currencyCode: tCurrencyCode)));
        },
      );

      blocTest<CurrencyBloc, CurrencyState>(
        'should emit [DailyRatesLoading, CurrencyError] when getting data fails',
        build: () {
          when(mockGetDailyRates(any))
              .thenAnswer((_) async => const Left(ServerFailure('Server error')));
          return currencyBloc;
        },
        act: (bloc) => bloc.add(const LoadDailyRates(currencyCode: tCurrencyCode)),
        expect: () => [
          const DailyRatesLoading(),
          const CurrencyError('Server error. Please try again later.', isDaily: true),
        ],
      );
    });
  });
}
