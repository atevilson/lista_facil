# Lista Fácil

## Sobre

A Lista Fácil é um aplicativo de gerenciamento de listas que permite aos usuários criar, organizar e compartilhar suas listas de itens de forma conveniente. Abaixo contêm uma visão geral das funcionalidades do aplicativo, bem como detalhes sobre o banco de dados utilizado na aplicação.

### Apresentação do app

[![Demonstração do App](https://cdn.loom.com/sessions/thumbnails/dd9b18b62aae4455b5fdafd388d30da8-with-play.gif)](https://www.loom.com/share/dd9b18b62aae4455b5fdafd388d30da8)

### Funcionalidades do Aplicativo

### 1. Criar Listas de compras

Os usuários podem criar várias listas para categorizar seus itens de acordo com suas preferências e necessidades.

### 2. Adicionar Itens a uma Lista Específica

Após criar uma lista, os usuários podem adicionar itens a ela, especificando detalhes como nome e quantidade.

### 3. Ordenar os Itens

Os itens em uma lista podem ser ordenados de acordo com a preferência do usuário, seja do maior para o menor ou vice-versa, facilitando a organização e visualização.

### 4. Selecionar os Itens

Os usuários podem selecionar itens individualmente para controle de itens adquiridos no carrinho de um supermercado ou estabelecimento.

### 5. Excluir Item por Item da Lista

Para uma gestão precisa das listas, os usuários podem excluir itens individualmente, conforme necessário.

### 6. Compartilhar os Itens nas Redes Sociais

Os itens das listas podem ser compartilhados facilmente em redes sociais, permitindo aos usuários compartilhar suas listas com amigos e familiares.

### 7. Excluir uma Lista com seus Respectivos Itens

Os usuários têm a capacidade de excluir uma lista inteira juntamente com todos os itens contidos nela, proporcionando uma maneira eficaz de limpar e gerenciar suas listas.

### Banco de Dados

A Lista Fácil utiliza o Sqflite como banco de dados para armazenar todas as informações relacionadas às listas e seus respectivos itens. Sqflite é uma biblioteca de banco de dados SQLite para Flutter que oferece uma solução leve e eficiente para o armazenamento de dados local.

Para cada lista criada pelo usuário, uma tabela correspondente é criada no banco de dados Sqflite para armazenar os itens relacionados a essa lista. Cada item é representado como uma linha na tabela, com seus atributos (nome e quantidade) armazenados em colunas separadas.

O uso do Sqflite garante uma experiência de usuário rápida e responsiva, com acesso rápido aos dados armazenados localmente no dispositivo do usuário.

### O projeto está organizado da seguinte forma:

- `lib/`: Código fonte do aplicativo.
- `assests/app.gif`: Apresentação do app.
- `main.dart`: Ponto de entrada/root do aplicativo.
- `components/`: widgets de entrada de dados.
- `controllers`: Controladores.
- `screens/`: Telas do app.
- `models/`: Modelos de tipagem do app.
- `datatbase`: Banco de dados do app.
- `utils_colors`: Módulo de cores para o app.

### Autor
---

 <sub><b>Atevilson Freitas</b></sub></a> <a href="">🧑‍💻</a>
