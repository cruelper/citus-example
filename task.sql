SELECT master_get_active_worker_nodes();


create table subject
(
    id serial PRIMARY KEY,
    name text NOT NULL
);

create table educational_form
(
    id serial PRIMARY KEY,
    name text NOT NULL
);

create table graduate_type
(
    id serial PRIMARY KEY,
    name text NOT NULL
);

CREATE TABLE specialization (
  id serial PRIMARY KEY,
  code text NOT NULL,
  name text NOT NULL
);

CREATE TABLE educational_group (
  num text,
  specialization_id int REFERENCES specialization (id),
  educational_form_id int REFERENCES educational_form(id),
  PRIMARY KEY (specialization_id, num)
);

CREATE TABLE educational_plan_unit (
  id serial,
  specialization_id int REFERENCES specialization (id),
  subject_id int REFERENCES subject(id),
  semester_num smallint NOT NULL,
  hour_count smallint NOT NULL,
  graduate_type_id smallint REFERENCES graduate_type (id),
  year int NOT NULL,
  PRIMARY KEY (specialization_id, id)
);

CREATE TABLE student (
  id bigserial,
  specialization_id int,
  educational_group_num text,
  name text NOT NULL,
  surname text NOT NULL,
  patronymic text NOT NULL,
  admission_year int,
  PRIMARY KEY (specialization_id, id),
  FOREIGN KEY (specialization_id, educational_group_num)
    REFERENCES educational_group (specialization_id, num)
);

CREATE TABLE journal (
  specialization_id int,
  student_id bigint,
  educational_plan_unit_id int,
  rate smallint NOT NULL ,
  PRIMARY KEY (specialization_id, educational_plan_unit_id, student_id),
  FOREIGN KEY (specialization_id, student_id)
    REFERENCES student (specialization_id, id),
  FOREIGN KEY (specialization_id, educational_plan_unit_id)
    REFERENCES educational_plan_unit (specialization_id, id)
);

begin;
Select citus_remove_node('citus_worker_5', 5432);
Select citus_remove_node('citus_worker_4', 5432);
Select citus_remove_node('citus_worker_3', 5432);
end;

SELECT create_distributed_table('specialization',        'id');
SELECT create_distributed_table('educational_group',     'specialization_id');
SELECT create_distributed_table('educational_plan_unit', 'specialization_id');
SELECT create_distributed_table('student',               'specialization_id');
SELECT create_distributed_table('journal',               'specialization_id');

SELECT create_reference_table('subject');
SELECT create_reference_table('educational_form');
SELECT create_reference_table('graduate_type');

INSERT INTO subject (name) VALUES
('АИС'),
('АВСиКС'),
('ТерВер'),
('Системы ИИ'),
('КГ');
SELECT * FROM subject;


INSERT INTO educational_form (name) VALUES
('Очная'),
('Очно-заочная'),
('Заочная');
SELECT * FROM educational_form;


INSERT INTO graduate_type (name) VALUES
('Зачет'),
('Экзамен');
SELECT * FROM graduate_type;


INSERT INTO specialization (code, name) VALUES
('020303', 'МОиАИС'),
('100301', 'Информационная безопасность');
SELECT * FROM specialization;


INSERT INTO educational_group (num, specialization_id, educational_form_id) VALUES
    ('4445', 1, 1),
    ('4345', 1, 2),
    ('4245', 1, 3),
    ('6143', 2, 1),
    ('6243', 2, 2);
SELECT * FROM educational_group;


INSERT INTO educational_plan_unit (specialization_id, subject_id, semester_num, hour_count, graduate_type_id, year) VALUES
    (1, 1, 1, 72, 1, 2022),
    (1, 2, 1, 36, 1, 2022),
    (1, 3, 2, 18, 1, 2022),
    (1, 4, 2, 72, 1, 2022),
    (1, 5, 2, 36, 2, 2022),
    (2, 1, 1, 72, 2, 2022),
    (2, 2, 1, 36, 1, 2022),
    (2, 3, 2, 108, 2, 2022),
    (2, 4, 2, 72, 1, 2022),
    (2, 5, 2, 36, 2, 2022);
SELECT * FROM educational_plan_unit;


INSERT INTO student (specialization_id, educational_group_num, name, surname, patronymic, admission_year) VALUES
    (1, '4445', 'Иван', 'Иванов', 'Иванович', 2021),
    (1, '4445', 'Петр', 'Петров', 'Петрович', 2022),
    (1, '4345', 'Сидор', 'Сидоров', 'Сидорович', 2021),
    (1, '4345', 'Мария', 'Маринина', 'Марковна', 2022),
    (1, '4345', 'Алексей', 'Алексеев', 'Алексеевич', 2021),
    (1, '4245', 'Ольга', 'Ольгова', 'Ольговна', 2021),
    (1, '4245', 'Николай', 'Николаев', 'Николаевич', 2022),
    (2, '6143', 'Анна', 'Аннова', 'Анновна', 2022),
    (2, '6143', 'Ирина', 'Иринина', 'Ириновна', 2021),
    (2, '6143', 'Виктор', 'Викторов', 'Викторович', 2022),
    (2, '6243', 'Елена', 'Еленова', 'Еленовна', 2021),
    (2, '6243', 'Артем', 'Артемов', 'Артемович', 2022),
    (2, '6243', 'Татьяна', 'Татьянова', 'Татьяновна', 2022);
SELECT * FROM student;


INSERT INTO journal (specialization_id, student_id, educational_plan_unit_id, rate) VALUES
    (1, 27, 1, 1),
    (1, 28, 1, 1),
    (1, 29, 1, 1),
    (1, 30, 2, 0),
    (1, 31, 2, 1),
    (1, 32, 2, 1),
    (1, 33, 3, 1),
    (1, 27, 3, 0),
    (1, 28, 3, 0),
    (1, 29, 4, 1),
    (1, 30, 4, 1),
    (1, 31, 5, 1),
    (1, 32, 5, 1),
    (1, 33, 5, 0),
    (2, 34, 6, 2),
    (2, 35, 6, 5),
    (2, 36, 6, 4),
    (2, 37, 6, 3),
    (2, 38, 6, 5),
    (2, 39, 6, 5),
    (2, 34, 7, 4),
    (2, 35, 7, 3),
    (2, 36, 7, 5),
    (2, 37, 7, 4),
    (2, 38, 7, 5),
    (2, 39, 8, 4),
    (2, 34, 8, 5),
    (2, 35, 8, 4),
    (2, 36, 8, 3),
    (2, 37, 8, 5),
    (2, 38, 9, 4),
    (2, 39, 9, 3),
    (2, 34, 9, 5),
    (2, 35, 10, 4),
    (2, 36, 10, 3);
SELECT * FROM journal;

select * from citus_shards;

select * from student where specialization_id=1; --4ms
select * from student where specialization_id=1 or specialization_id=2; --20ms

SELECT shardid, shardstate, shardlength, nodename, nodeport, placementid
  FROM pg_dist_placement AS placement,
       pg_dist_node AS node
 WHERE placement.groupid = node.groupid
   AND node.noderole = 'primary'
   AND shardid = (
     SELECT get_shard_id_for_distribution_column('journal', 2)
   );

SELECT shardid, shardstate, shardlength, nodename, nodeport, placementid
  FROM pg_dist_placement AS placement,
       pg_dist_node AS node
 WHERE placement.groupid = node.groupid
   AND node.noderole = 'primary'
   AND shardid = (
     SELECT get_shard_id_for_distribution_column('subject', 2)
   );


-- остановка одного из воркеров
SELECT * FROM educational_group;
-- ERROR:  connection to the remote node citus_worker_1:5432 failed with the following error: could not translate host name "citus_worker_1" to address: Name or service not known


-- ЗАДАНИЕ 1
-- для указанной формы обучения посчитать количество студентов этой формы обучения
-- Set citus.enable_repartition_joins to on;
-- SELECT count(student)
--   FROM student,
--        educational_group,
--        educational_form
--  WHERE student.educational_group_num = educational_group.num
--    AND educational_group.educational_form_id = educational_form.id
--    AND educational_form.name='Очная';

CREATE OR REPLACE FUNCTION count_students_by_educational_form(form text)
RETURNS INTEGER AS $$
BEGIN
  SET citus.enable_repartition_joins = on;
  RETURN (
    SELECT count(student)
      FROM student
      JOIN educational_group ON student.specialization_id = educational_group.specialization_id AND student.educational_group_num = educational_group.num
      JOIN educational_form ON educational_group.educational_form_id = educational_form.id
     WHERE educational_form.name = form
  );
END;
$$ LANGUAGE plpgsql;

select count_students_by_educational_form('Заочная');

-- ЗАДАНИЕ 2
-- для указанной дисциплины получить количество часов и формы отчетности по этой дисциплине;
-- SELECT educational_plan_unit.hour_count,
--        graduate_type.name,
--        specialization.name
--   FROM educational_plan_unit,
--        graduate_type,
--        subject,
--        specialization
--  WHERE educational_plan_unit.subject_id = subject.id
--    AND educational_plan_unit.graduate_type_id = graduate_type.id
--    AND educational_plan_unit.specialization_id = specialization.id
--    AND subject.name = 'АИС';

CREATE OR REPLACE FUNCTION get_hours_and_graduate_type_and_specialization_name_by_subject(some_subject text)
RETURNS TABLE (hour_count SMALLINT, graduate_type_name TEXT, specialization_name TEXT) AS $$
BEGIN
  RETURN QUERY
    SELECT educational_plan_unit.hour_count, graduate_type.name, specialization.name
      FROM educational_plan_unit
      JOIN graduate_type ON educational_plan_unit.graduate_type_id = graduate_type.id
      JOIN subject ON educational_plan_unit.subject_id = subject.id
      JOIN specialization ON educational_plan_unit.specialization_id = specialization.id
     WHERE subject.name = some_subject;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_hours_and_graduate_type_and_specialization_name_by_subject('АИС');

-- ЗАДАНИЕ 3
-- предоставить возможность добавления и изменения информации о студентах, об
-- учебных планах, о журнале успеваемости при этом предусмотреть курсоры,
-- срабатывающие на некоторые пользовательские исключительные ситуации;

-- Добавление студента
CREATE OR REPLACE FUNCTION add_student (
  educational_group_num text,
  name text,
  surname text,
  patronymic text,
  admission_year int
) RETURNS void AS $$
DECLARE
  group_exists boolean;
  student_specialization_id int;
BEGIN
  -- Проверяем, существует ли группа с заданным номером
  SELECT EXISTS (
    SELECT 1
    FROM educational_group
    WHERE educational_group.num = add_student.educational_group_num
  ) INTO group_exists;

  -- Если группа не существует, выбрасываем исключение
  IF NOT group_exists THEN
    RAISE EXCEPTION 'Educational group with number % does not exist', educational_group_num;
  END IF;

--   Ищем id специальности
  SELECT educational_group.specialization_id
    FROM educational_group
   WHERE educational_group.num = add_student.educational_group_num
   LIMIT 1
    INTO student_specialization_id;

  -- Добавляем студента в таблицу student
  INSERT INTO student (specialization_id, educational_group_num, name, surname, patronymic, admission_year)
  VALUES (student_specialization_id, educational_group_num, name, surname, patronymic, admission_year);
END;
$$ LANGUAGE plpgsql;

SELECT add_student('4445', 'Андрей', 'Андреев', 'Андреевич', 2019);

-- Обновление студента
CREATE OR REPLACE FUNCTION update_student (
  student_id int,
  name text,
  surname text,
  patronymic text,
  admission_year int
) RETURNS void AS $$
BEGIN
  -- Обновляем студента
  UPDATE student
  SET name = update_student.name,
      surname = update_student.surname,
      patronymic = update_student.patronymic,
      admission_year = update_student.admission_year
  WHERE id = student_id;
END;
$$ LANGUAGE plpgsql;

SELECT update_student(40, 'Андрей', 'Андреев', 'Андреевич', 2018);


-- Добавление учебного плана
CREATE OR REPLACE FUNCTION add_educational_plan_unit (
  specialization_id int,
  subject_id int,
  semester_num int,
  hour_count int,
  graduate_type_id int,
  year int
) RETURNS void AS $$
BEGIN
  -- Добавляем новую запись в таблицу educational_plan_unit
  INSERT INTO educational_plan_unit (specialization_id, subject_id, semester_num, hour_count, graduate_type_id, year)
  VALUES (
          add_educational_plan_unit.specialization_id,
          add_educational_plan_unit.subject_id,
          add_educational_plan_unit.semester_num,
          add_educational_plan_unit.hour_count,
          add_educational_plan_unit.graduate_type_id, year
          );
END;
$$ LANGUAGE plpgsql;

SELECT add_educational_plan_unit(2,2,2,48,2, 2022);

-- Обновление учебного плана
CREATE OR REPLACE FUNCTION update_educational_plan_unit (
  educational_plan_unit_id int,
  subject_id int,
  semester_num int,
  hour_count int,
  graduate_type_id int,
  year int
) RETURNS void AS $$
BEGIN
  -- Обновляем информацию об учебном плане
  UPDATE educational_plan_unit
  SET subject_id = update_educational_plan_unit.subject_id,
      semester_num = update_educational_plan_unit.semester_num,
      hour_count = update_educational_plan_unit.hour_count,
      graduate_type_id = update_educational_plan_unit.graduate_type_id,
      year = update_educational_plan_unit.year
  WHERE id = educational_plan_unit_id;
END;
$$ LANGUAGE plpgsql;

SELECT update_educational_plan_unit(11, 2, 2, 48, 1, 2022);

-- Добавление записи в журнал
CREATE OR REPLACE FUNCTION add_journal_unit (
  student_id int,
  educational_plan_unit_id int,
  rate int
) RETURNS void AS $$
DECLARE
  student_exists boolean;
  educational_plan_unit_exists boolean;
  student_specialization_id int;
BEGIN
  -- Проверяем, существует ли студент с заданным id
  SELECT EXISTS (
    SELECT 1
    FROM student
    WHERE student.id = add_journal_unit.student_id
  ) INTO student_exists;

  -- Если студент не существует, выбрасываем исключение
  IF NOT student_exists THEN
    RAISE EXCEPTION 'Student with id % does not exist', student_id;
  END IF;

--   Ищем id специальности
  SELECT student.specialization_id
    FROM student
   WHERE student.id = add_journal_unit.student_id
   LIMIT 1
    INTO student_specialization_id;

    -- Проверяем, существует ли учебный план с заданным id
  SELECT EXISTS (
    SELECT 1
    FROM educational_plan_unit
    WHERE educational_plan_unit.id = add_journal_unit.educational_plan_unit_id
      AND educational_plan_unit.specialization_id = student_specialization_id
  ) INTO educational_plan_unit_exists;

  -- Если учебный план не существует, выбрасываем исключение
  IF NOT educational_plan_unit_exists THEN
    RAISE EXCEPTION 'Educational plan unit with id % does not exist', educational_plan_unit_id;
  END IF;

  -- Добавляем запись журнала
  INSERT INTO journal (specialization_id, student_id, educational_plan_unit_id, rate)
  VALUES (
          student_specialization_id,
          add_journal_unit.student_id,
          add_journal_unit.educational_plan_unit_id,
          add_journal_unit.rate
          );
END;
$$ LANGUAGE plpgsql;

SELECT add_journal_unit(40, 5, 4);

-- Обноление записи журнала
CREATE OR REPLACE FUNCTION update_journal_unit (
  student_id int,
  educational_plan_unit_id int,
  rate int
) RETURNS void AS $$
DECLARE
  student_exists boolean;
  educational_plan_unit_exists boolean;
  journal_unit_exists boolean;
  student_specialization_id int;
BEGIN
  -- Проверяем, существует ли студент с заданным id
  SELECT EXISTS (
    SELECT 1
    FROM student
    WHERE student.id = update_journal_unit.student_id
  ) INTO student_exists;

  -- Если студент не существует, выбрасываем исключение
  IF NOT student_exists THEN
    RAISE EXCEPTION 'Student with id % does not exist', student_id;
  END IF;

--   Ищем id специальности
  SELECT student.specialization_id
    FROM student
   WHERE student.id = update_journal_unit.student_id
   LIMIT 1
    INTO student_specialization_id;

    -- Проверяем, существует ли учебный план с заданным id
  SELECT EXISTS (
    SELECT 1
    FROM educational_plan_unit
    WHERE educational_plan_unit.id = update_journal_unit.educational_plan_unit_id
      AND educational_plan_unit.specialization_id = student_specialization_id
  ) INTO educational_plan_unit_exists;

  -- Если учебный план не существует, выбрасываем исключение
  IF NOT educational_plan_unit_exists THEN
    RAISE EXCEPTION 'Educational plan unit with id % does not exist', educational_plan_unit_id;
  END IF;

    -- Проверяем, существует ли запись журнала
  SELECT EXISTS (
    SELECT 1
      FROM journal
     WHERE journal.student_id = update_journal_unit.student_id
       AND journal.educational_plan_unit_id = update_journal_unit.educational_plan_unit_id
  ) INTO journal_unit_exists;

  -- Если учебный план не существует, выбрасываем исключение
  IF NOT journal_unit_exists THEN
    RAISE EXCEPTION 'Journal with id % does not exist', educational_plan_unit_id;
  END IF;

  -- Добавляем запись журнала
  UPDATE journal
     SET rate = update_journal_unit.rate
   WHERE journal.student_id = update_journal_unit.student_id
     AND journal.educational_plan_unit_id = update_journal_unit.educational_plan_unit_id;
END;
$$ LANGUAGE plpgsql;

SELECT update_journal_unit(40, 5, 5);


-- Триггеры

-- тригер на вставку записи в журнал. чтобы нельзя было вставлять в зачет оценку <0 || >1, а в экзамен выше <0 || >5
CREATE OR REPLACE FUNCTION check_graduate_rate()
RETURNS TRIGGER AS $$
DECLARE
  grad_type_id integer;
BEGIN
  SELECT graduate_type_id INTO grad_type_id FROM educational_plan_unit WHERE id = NEW.educational_plan_unit_id;

  IF  NEW.rate < 0 OR (grad_type_id = 1 AND NEW.rate > 1) OR grad_type_id = 2 AND NEW.rate > 5 THEN
    RAISE EXCEPTION 'Cannot insert or update journal. Rate out of range';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

SELECT run_command_on_shards(
  'journal',
  $cmd$
    CREATE TRIGGER check_graduate_rate_trigger
    BEFORE INSERT OR UPDATE ON %s
      FOR EACH ROW EXECUTE FUNCTION check_graduate_rate()
  $cmd$
);

alter user root set citus.allow_nested_distributed_execution to on;

SELECT update_journal_unit(40, 5, 5);

-- каскадные тригеры для изменения specialization
CREATE OR REPLACE FUNCTION cascade_update_student()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.specialization_id != OLD.specialization_id THEN
      UPDATE student
      SET specialization_id = NEW.specialization_id
      WHERE student.specialization_id = OLD.specialization_id AND student.educational_group_num = OLD.num;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

SELECT run_command_on_shards(
  'educational_group',
  $cmd$
    CREATE TRIGGER cascade_update_student_trigger
    AFTER UPDATE ON %s
    FOR EACH ROW
    EXECUTE FUNCTION cascade_update_student();
  $cmd$
);

CREATE OR REPLACE FUNCTION cascade_update_journal()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.specialization_id != OLD.specialization_id THEN
    UPDATE journal
    SET specialization_id = NEW.specialization_id
    WHERE journal.specialization_id = OLD.specialization_id AND journal.student_id = OLD.id;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

SELECT run_command_on_shards(
  'student',
  $cmd$
    CREATE TRIGGER cascade_update_journal_trigger
    AFTER UPDATE ON %s
    FOR EACH ROW
    EXECUTE FUNCTION cascade_update_journal();
  $cmd$
);

UPDATE educational_group
  SET specialization_id = 0
  WHERE specialization_id = 1;
