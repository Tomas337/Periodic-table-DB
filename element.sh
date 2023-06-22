#!/bin/bash
if [[ $# -eq 0 ]]
then
  echo "Please provide an element as an argument."
else
  PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
  COLUMNS=("atomic_number" "symbol" "name")
  I=0

  while [[ $I -lt 3 ]]
  do
    ELEMENT_RESULT=$($PSQL "SELECT * FROM elements WHERE ${COLUMNS[$I]} = '$1'" 2>/dev/null)
    if [[ $ELEMENT_RESULT -ne 0 ]]
    then
      IFS="|" read -ra ELEMENT <<< "$ELEMENT_RESULT";

      PROPERTIES_RESULT=$($PSQL "SELECT * FROM properties WHERE atomic_number = ${ELEMENT[0]}")
      IFS="|" read -ra PROPERTIES <<< "$PROPERTIES_RESULT";

      TYPE_RESULT=$($PSQL "SELECT * FROM types WHERE type_id = ${PROPERTIES[4]}")
      IFS="|" read -ra TYPE <<< "$TYPE_RESULT";

      echo "The element with atomic number ${ELEMENT[0]} is ${ELEMENT[2]} (${ELEMENT[1]}). It's a ${TYPE[0]}, with a mass of ${PROPERTIES[1]} amu. ${ELEMENT[2]} has a melting point of ${PROPERTIES[2]} celsius and a boiling point of ${PROPERTIES[3]} celsius."

      I=4 # ends program
    fi
    I=$I+1
  done

  if [[ $I -eq 3 ]]
  then
    echo "I could not find that element in the database."
  fi
fi
