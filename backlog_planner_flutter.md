
# 📌 Backlog Detalhado - Planner Virtual (Flutter/Dart)

Este documento contém todas as **User Stories (US)** e suas **subtasks (ST)** vinculadas aos respectivos épicos para importação no GitHub Projects.

---

## 🎯 Épico 1 – Gestão de Metas

### US01 – Criar metas semanais, mensais e anuais
- [ ] **ST01.1** – Criar modelo `Meta` com campos: título, descrição, período, categoria, status.
- [ ] **ST01.2** – Criar tela de listagem de metas (ListView com separação por período).
- [ ] **ST01.3** – Criar tela de cadastro/edição de meta (Form com Dropdown para período).
- [ ] **ST01.4** – Integrar persistência local (Hive ou SQLite) para salvar metas.

### US02 – Marcar metas como atingidas, parcialmente ou não atingidas
- [ ] **ST02.1** – Adicionar campo `status` no modelo `Meta`.
- [ ] **ST02.2** – Criar controle de atualização de status na tela de detalhes (Toggle/Dropdown).
- [ ] **ST02.3** – Atualizar persistência ao mudar status.

### US03 – Categorizar metas
- [ ] **ST03.1** – Criar lista de categorias pré-definidas.
- [ ] **ST03.2** – Adicionar seleção de categoria no cadastro de meta.
- [ ] **ST03.3** – Aplicar cor da categoria no card de exibição.

---

## 🗓️ Épico 2 – Planejamento de Tarefas Diárias

### US04 – Criar tarefas para blocos de tempo
- [ ] **ST04.1** – Criar modelo `Tarefa` com título, descrição, bloco de tempo, categoria e status.
- [ ] **ST04.2** – Criar tela de listagem de tarefas por dia (Calendar + ListView).
- [ ] **ST04.3** – Criar tela de cadastro de tarefa com seleção de bloco de tempo.
- [ ] **ST04.4** – Implementar salvamento no banco local.

### US05 – Marcar tarefas como executadas, parcialmente ou adiadas
- [ ] **ST05.1** – Adicionar campo `status` no modelo `Tarefa`.
- [ ] **ST05.2** – Criar controle para atualizar status (Dropdown ou Botões rápidos).
- [ ] **ST05.3** – Atualizar persistência ao mudar status.

### US06 – Categorizar tarefas
- [ ] **ST06.1** – Criar lista de categorias pré-definidas.
- [ ] **ST06.2** – Adicionar escolha de categoria no cadastro de tarefa.
- [ ] **ST06.3** – Aplicar cor no card da tarefa conforme categoria.

---

## 🔔 Épico 3 – Lembretes Semanais

### US07 – Criar lembretes para ligações
- [ ] **ST07.1** – Criar modelo `Lembrete` com título, tipo, data e recorrência.
- [ ] **ST07.2** – Criar tela de cadastro de lembrete com tipo "Ligação" pré-selecionado.
- [ ] **ST07.3** – Integrar com `flutter_local_notifications` para disparar notificação.

### US08 – Criar lembretes para reuniões
- [ ] **ST08.1** – Criar opção "Reunião" na criação de lembrete.
- [ ] **ST08.2** – Criar exibição de lembretes de reunião na lista semanal.

### US09 – Criar lembretes para compras/afazeres
- [ ] **ST09.1** – Criar opção "Compras/Afazer" na criação de lembrete.
- [ ] **ST09.2** – Integrar com lista de tarefas quando possível.

---

## 📊 Épico 4 – Relatórios e Análises

### US10 – Gerar relatórios de conclusão
- [ ] **ST10.1** – Criar função para calcular % de metas concluídas e tarefas executadas.
- [ ] **ST10.2** – Criar tela de visualização de relatório.
- [ ] **ST10.3** – Usar `fl_chart` para exibir gráficos.

### US11 – Visualizar turnos, semanas e meses mais produtivos
- [ ] **ST11.1** – Criar função que analisa banco e identifica períodos mais produtivos.
- [ ] **ST11.2** – Mostrar no relatório gráfico ou tabela com ranking.

### US12 – Saber quais categorias são mais realizadas
- [ ] **ST12.1** – Criar contagem por categoria.
- [ ] **ST12.2** – Exibir gráfico de pizza com a distribuição.

---

## 🗄️ Épico 5 – Armazenamento de Dados

### US13 – Persistir dados localmente
- [ ] **ST13.1** – Configurar Hive ou SQLite no Flutter.
- [ ] **ST13.2** – Criar adapters para `Meta`, `Tarefa` e `Lembrete`.
- [ ] **ST13.3** – Garantir que todos os CRUDs usem a persistência.

---

## 🖼️ Épico 6 – Interface do Usuário

### US14 – Interface clara e intuitiva
- [ ] **ST14.1** – Criar tema de cores no `ThemeData`.
- [ ] **ST14.2** – Criar componentes customizados para cards de metas, tarefas e lembretes.
- [ ] **ST14.3** – Adicionar responsividade com `LayoutBuilder` ou `MediaQuery`.
- [ ] **ST14.4** – Adicionar feedback visual (snackbars, animações simples).
