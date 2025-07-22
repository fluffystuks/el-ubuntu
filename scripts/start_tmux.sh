#!/bin/bash

SESSION="my_session"
FILE_TO_EDIT="$HOME/ege/main.c"

# Создаём новую tmux-сессию
tmux new-session -d -s $SESSION -n cats

# Первый сплит: перейти в папку и открыть файл
tmux send-keys -t $SESSION "cd ~/ege" C-m
tmux send-keys -t $SESSION "nvim main.c" C-m

# Немного подождать (иначе ctrl+n может проигнорироваться)
sleep 0.3
tmux send-keys -t $SESSION C-n  # Нажимаем Ctrl+n внутри nvim

# Делим окно вертикально (второй сплит справа)
tmux split-window -h -t $SESSION

# Второй сплит: перейти в папку и запустить ondo
tmux send-keys -t ${SESSION}:1.2 "cd ~/ege" C-m
tmux send-keys -t ${SESSION}:1.2 'ondo "*.c" "make && ./main"' C-m

# Второе окно (просто пустое)
tmux new-window -t $SESSION -n "and dogs"

# Вернуться в первый окно (editor)
tmux select-window -t ${SESSION}:1
# Переход в левую панель
tmux select-pane -t ${SESSION}:1.1

# Послать Ctrl+L в левую панель (очистка терминала внутри неё)
tmux send-keys -t ${SESSION}:1.1 C-l


# Подключаемся к сессии
tmux attach-session -t $SESSION
