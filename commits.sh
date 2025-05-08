#!/bin/bash

# Configurar rango de fechas
start_date="2025-03-22"
end_date="2025-05-7"

current_date="$start_date"

while [ "$current_date" != "$(date -I -d "$end_date + 1 day")" ]; do
  # Obtener el día de la semana (1=Lunes, 7=Domingo)
  day_of_week=$(date -d "$current_date" +%u)

  # Definir el rango de commits según el día
  if [ "$day_of_week" -eq 6 ] || [ "$day_of_week" -eq 7 ]; then
    # Sábado o domingo: 1-5 commits
    num_commits=$(shuf -i 1-5 -n 1)
  else
    # Lunes a viernes: 5-15 commits
    num_commits=$(shuf -i 5-15 -n 1)
  fi

  for i in $(seq 1 $num_commits); do
    # Generar una hora aleatoria para el commit
    random_hour=$(shuf -i 0-23 -n 1)
    random_minute=$(shuf -i 0-59 -n 1)
    random_second=$(shuf -i 0-59 -n 1)

    # Formatear la hora para asegurar dos dígitos
    formatted_time=$(printf "%02d:%02d:%02d" $random_hour $random_minute $random_second)

    # Establecer la fecha y hora del commit
    export GIT_COMMITTER_DATE="$current_date $formatted_time"
    GIT_AUTHOR_DATE="$current_date $formatted_time" git commit --allow-empty -m "Commit del día $current_date, número $i" --date="$current_date $formatted_time"
  done

  # Avanzar al siguiente día
  current_date=$(date -I -d "$current_date + 1 day")
done

# Push al repositorio remoto
git push origin main