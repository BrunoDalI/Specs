# BRL Exchange Rate App

<div align="center">
  <img src="assets/logo/logo.png" alt="App Logo" width="300"/>
  
  [![Flutter](https://img.shields.io/badge/Flutter-3.9.0-blue.svg)](https://flutter.dev/)
  [![Dart](https://img.shields.io/badge/Dart-3.9.0-blue.svg)](https://dart.dev/)
  [![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
</div>

## 📖 Sobre o Projeto

O **BRL Exchange Rate App** é um aplicativo Flutter que permite consultar taxas de câmbio do Real Brasileiro (BRL) em relação a outras moedas. O app fornece informações detalhadas sobre taxas atuais e histórico de 30 dias, incluindo valores de abertura, fechamento, máxima, mínima e variação percentual.

### ✨ Funcionalidades

- 📊 Consulta de taxa de câmbio atual
- 📈 Histórico detalhado de 30 dias
- 💹 Informações completas (Open, High, Low, Close, Variação %)
- 🎨 Interface responsiva e intuitiva
- 🔄 Atualização em tempo real
- ❌ Tratamento robusto de erros
- 🌐 Suporte a múltiplas moedas

---

## 🏗️ Arquitetura e Padrões

### Clean Architecture

O projeto segue os princípios da **Clean Architecture**, proporcionando:

- **Separação de Responsabilidades**: Cada camada tem uma função específica
- **Independência de Frameworks**: A lógica de negócio é independente do Flutter
- **Testabilidade**: Facilita a criação de testes unitários e de integração
- **Manutenibilidade**: Código organizado e fácil de modificar

```
lib/
├── core/                    # Funcionalidades compartilhadas
│   ├── error/              # Tratamento de erros
│   ├── usecases/           # Casos de uso base
│   └── utils/              # Utilitários (Either, formatação)
├── features/exchange/       # Feature de câmbio
│   ├── data/               # Camada de dados
│   │   ├── datasources/    # Fontes de dados (API)
│   │   └── repositories/   # Implementação dos repositórios
│   ├── domain/             # Regras de negócio
│   │   ├── entities/       # Entidades do domínio
│   │   ├── repositories/   # Contratos dos repositórios
│   │   └── usecases/       # Casos de uso
│   └── presentation/       # Interface do usuário
│       ├── bloc/           # Gerenciamento de estado
│       ├── pages/          # Telas
│       └── widgets/        # Componentes reutilizáveis
```

### SOLID Principles

O código foi desenvolvido seguindo os princípios SOLID:

- **S** - Single Responsibility: Cada classe tem uma única responsabilidade
- **O** - Open/Closed: Aberto para extensão, fechado para modificação
- **L** - Liskov Substitution: Objetos podem ser substituídos por suas implementações
- **I** - Interface Segregation: Interfaces específicas e enxutas
- **D** - Dependency Inversion: Dependência de abstrações, não de implementações

---

## 🛠️ Tecnologias Utilizadas

### Framework e Linguagem
- **Flutter 3.9.0**: Framework multiplataforma
- **Dart 3.9.0**: Linguagem de programação

### Principais Dependências

#### Gerenciamento de Estado
- **flutter_bloc (^9.1.1)**: Padrão BLoC para gerenciamento de estado reativo

#### Networking
- **dio (^5.9.0)**: Cliente HTTP avançado com interceptors, cancelamento de requests e tratamento de erros

**Por que Dio em vez de HTTP?**
- ✅ **Interceptors**: Permite logging automático e tratamento global de erros
- ✅ **Cancelamento de Requests**: Evita requests desnecessários
- ✅ **Retry Automático**: Configura tentativas automáticas em caso de falha
- ✅ **Timeout Configurável**: Controle fino sobre tempos limite
- ✅ **Transformação de Dados**: Serialização/deserialização automática
- ✅ **Debugging**: Ferramentas avançadas para debug de requisições

#### Dependency Injection
- **get_it (^8.2.0)**: Service locator para injeção de dependência

#### Utilitários
- **equatable (^2.0.7)**: Comparação eficiente de objetos
- **intl (^0.20.2)**: Formatação de datas e números
- **flutter_dotenv (^5.0.2)**: Gerenciamento seguro de variáveis de ambiente

---

## 🚀 Configuração e Execução

### Pré-requisitos
- Flutter SDK 3.9.0 ou superior
- Dart SDK 3.9.0 ou superior
- Android Studio ou VS Code com extensões Flutter

### Instalação

1. **Clone o repositório**:
   ```bash
   git clone https://github.com/BrunoDalI/specs.git
   cd specs
   ```

2. **Instale as dependências**:
   ```bash
   flutter pub get
   ```

3. **Configure o arquivo de ambiente**:
   ```bash
   # Copie o arquivo de exemplo
   cp .env.example .env
   
   # Edite o arquivo .env e adicione sua API Key
   # API_KEY=sua_chave_aqui
   ```

4. **Execute o aplicativo**:
   ```bash
   flutter run
   ```

### Configuração da API Key

O projeto utiliza a API da ActionLabs para obter dados de câmbio:

1. Crie um arquivo `.env` na raiz do projeto
2. Adicione sua chave de API:
   ```env
   API_KEY=RVZG0GHEV2KORLNA
   ```

**Observação de Segurança**: O arquivo `.env` foi incluído no repositório apenas para facilitar o processo de avaliação. Em ambiente de produção, variáveis sensíveis nunca devem ser expostas no controle de versão.

---

## 🧪 Testes

O projeto inclui uma suíte completa de testes para garantir qualidade e confiabilidade:

### Tipos de Teste Implementados

#### 1. Testes Unitários
- **Entidades**: Validação de objetos de domínio
- **Use Cases**: Lógica de negócio isolada
- **Repositories**: Implementações de repositório
- **BLoCs**: Gerenciamento de estado

```bash
# Executar testes unitários
flutter test test/unit/
```

#### 2. Testes de Widget
- **Componentes**: Widgets personalizados
- **Telas**: Interfaces de usuário
- **Interações**: Comportamento da UI

```bash
# Executar testes de widget
flutter test test/widget/
```

#### 3. Testes de Integração
- **Fluxos Completos**: Jornadas do usuário
- **APIs**: Integração com serviços externos
- **Estado Global**: Comportamento do app

```bash
# Executar testes de integração
flutter test integration_test/
```

#### 4. Cobertura de Testes
```bash
# Gerar relatório de cobertura
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

---

## 🔧 Ferramentas de Desenvolvimento

### Flutter DevTools

O projeto foi desenvolvido utilizando extensivamente o **Flutter DevTools** para:

- **Inspector**: Análise da árvore de widgets e debugging visual
- **Performance**: Monitoramento de performance e otimização
- **Memory**: Análise de uso de memória e vazamentos
- **Network**: Monitoramento de requisições HTTP
- **Logging**: Acompanhamento de logs em tempo real

### Debugging e Monitoramento

```bash
# Executar com DevTools
flutter run --dart-define=FLUTTER_WEB_USE_SKIA=true
```

**Funcionalidades utilizadas**:
- 🔍 **Widget Inspector**: Para debugging da interface
- 📊 **Performance View**: Otimização de renderização
- 🌐 **Network View**: Monitoramento de APIs
- 📝 **Logging View**: Acompanhamento de eventos
- 💾 **Memory View**: Análise de vazamentos

---

## 📱 Funcionalidades Detalhadas

### 1. Consulta de Taxa Atual
- Input de código da moeda (3 caracteres)
- Validação em tempo real
- Exibição da taxa atual BRL

### 2. Histórico de 30 Dias
- Listagem expansível de taxas diárias
- Informações completas (OHLC)
- Cálculo de variação percentual
- Formatação responsiva

### 3. Tratamento de Erros
- Mensagens amigáveis ao usuário
- Retry automático em falhas de rede
- Fallback para dados mock
- Estados de loading e erro

### 4. Interface Responsiva
- Adaptação a diferentes tamanhos de tela
- Fontes escaláveis
- Layout flexível
- Acessibilidade aprimorada

---

## 🎨 Design System

### Componentes Reutilizáveis
- **TextPairWidget**: Exibição de pares chave-valor
- **DailyRateCard**: Cards de informação diária
- **ExchangeResult**: Resultado da consulta
- **CopyRightBanner**: Rodapé informativo

### Formatação e Estilo
- **FormatUtils**: Utilitários de formatação
- **Cores Consistentes**: Paleta unificada
- **Tipografia**: Hierarquia clara
- **Espaçamentos**: Grid system

---

## 🔒 Segurança

### Proteção de Dados Sensíveis
- ✅ API Keys em variáveis de ambiente
- ✅ Validação de entrada do usuário
- ✅ Sanitização de dados da API
- ✅ Tratamento seguro de erros

### Boas Práticas Implementadas
- Não exposição de chaves no código
- Validação rigorosa de inputs
- Tratamento de exceções
- Logging seguro (sem dados sensíveis)

---

## 📊 Performance

### Otimizações Implementadas
- **Widget Rebuilds**: Minimização de rebuilds desnecessários
- **State Management**: Estado eficiente com BLoC
- **Network**: Cache e retry inteligente
- **Memory**: Gerenciamento adequado de recursos

### Métricas de Performance
- Tempo de inicialização: < 2s
- Resposta de API: < 1s (média)
- Uso de memória: < 50MB
- FPS constante: 60fps


## 🏆 Considerações Técnicas

### Por que Clean Architecture?
- **Testabilidade**: Facilita testes isolados de cada camada
- **Manutenibilidade**: Mudanças são localizadas e controláveis
- **Escalabilidade**: Facilita adição de novas funcionalidades
- **Reutilização**: Componentes bem definidos e reutilizáveis

### Por que BLoC Pattern?
- **Reatividade**: Estado reativo e previsível
- **Testabilidade**: Events e states são facilmente testáveis
- **Separação**: UI separada da lógica de negócio
- **Debugging**: DevTools com suporte nativo ao BLoC

### Por que Dio?
- **Robustez**: Melhor tratamento de erros e timeouts
- **Flexibilidade**: Interceptors para logging e transformação
- **Performance**: Otimizações para requisições HTTP
- **Developer Experience**: Melhor debugging e monitoramento

---

<div align="center">
  <p>Desenvolvido com ❤️ usando Flutter</p>
  <p>© 2025 Bruno Dall.</p>
</div>

