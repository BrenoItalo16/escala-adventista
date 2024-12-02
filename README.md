<img src="https://i.imgur.com/bOjfoWK.png"/>
<br>

# Escala Adventista

<div align="center">

<p align="center">
  <a href="https://skillicons.dev">
    <img src="https://skillicons.dev/icons?i=flutter,dart,firebase,git,vscode,androidstudio,figma" />
  </a>
</p>

</div>

Bem-vindo ao repositório **Escala Adventista**! Este projeto foi desenvolvido para facilitar o gerenciamento de escalas das atividades e serviços da igreja adventista. Através dele, líderes podem organizar e distribuir tarefas de forma eficiente e acessível para todos os membros envolvidos.

## Índice

- [Sobre o Projeto](#-sobre-o-projeto)
- [Tecnologias](#-tecnologias)
- [Começando](#-começando)
- [Funcionalidades](#-funcionalidades)
- [Arquitetura](#-arquitetura)
- [Guia de Desenvolvimento](docs/FEATURE_GUIDE.md)
- [Contribuindo](#-contribuindo)
- [Licença](#-licença)
- [Contato](#-contato)

## Sobre o Projeto

O **Escala Adventista** é uma ferramenta que auxilia na organização das atividades da igreja, distribuindo tarefas e gerenciando escalas de forma transparente e prática. Com uma interface intuitiva, permite que os usuários acessem facilmente suas responsabilidades e consultem as escalas das diversas funções semanais.

### Principais Características

- Interface moderna e intuitiva
- Gerenciamento eficiente de escalas
- Notificações e lembretes
- Perfis personalizados
- Relatórios e estatísticas

## Tecnologias

Este projeto foi desenvolvido com as seguintes tecnologias:

- [Flutter](https://flutter.dev/)
- [Dart](https://dart.dev/)
- [Firebase](https://firebase.google.com/)
- [BLoC Pattern](https://bloclibrary.dev/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

## Começando

### Pré-requisitos

- Flutter (versão 3.13.0 ou superior)
- Dart (versão 3.1.0 ou superior)
- Git
- Android Studio / VS Code

### Instalação

1. **Clone o Repositório**
   ```bash
   git clone https://github.com/brenoitalo16/escala-adventista.git
   ```

2. **Acesse o Diretório**
   ```bash
   cd escala-adventista
   ```

3. **Instale as Dependências**
   ```bash
   flutter pub get
   ```

4. **Configure o Firebase**
   - Crie um projeto no [Firebase Console](https://console.firebase.google.com/)
   - Adicione um aplicativo Android/iOS
   - Baixe o arquivo de configuração (`google-services.json` / `GoogleService-Info.plist`)
   - Siga as instruções de configuração do Firebase

5. **Execute o Projeto**
   ```bash
   flutter run
   ```

## Funcionalidades

### Implementadas
- [ ] Autenticação de usuários
- [ ] Criação de escalas
- [ ] Gerenciamento de perfis
- [ ] Notificações
- [ ] Relatórios básicos

### Em Desenvolvimento
- [ ] Sincronização offline
- [ ] Estatísticas avançadas
- [ ] Integração com calendário
- [ ] Exportação de dados
- [ ] Temas personalizados

## Arquitetura

O projeto segue os princípios do Clean Architecture e SOLID, organizado em camadas:

```
lib/
├── core/
├── features/
│   ├── auth/
│   ├── schedule/
│   └── profile/
├── shared/
└── main.dart
```

Para mais detalhes sobre a arquitetura e padrões de desenvolvimento, consulte nosso [Guia de Desenvolvimento](docs/FEATURE_GUIDE.md).

## Contribuindo

Contribuições são sempre bem-vindas! Para contribuir:

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

Consulte [CONTRIBUTING.md](CONTRIBUTING.md) para mais detalhes.

## Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## Contato

Breno Italo - [@brenoitalo16](https://instagram.com/brenoitalo16)

- Email: [contato@brenoitalo.com](mailto:contato@brenoitalo.com)
- GitHub: [brenoitalo16](https://github.com/brenoitalo16)
- LinkedIn: [brenoitalo](https://linkedin.com/in/brenoitalo)

---

<div align="center">

Feito com ❤️ por [Breno Italo](https://github.com/brenoitalo16)

</div>