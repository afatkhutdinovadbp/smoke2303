# Conduit — бэкенд на Ruby on Rails для проекта RealWorld

REST API для платформы публикации статей, реализованное на **Ruby on Rails 7**. Это серверная часть клона Medium.com под названием [Conduit](https://demo.realworld.io) — одного из эталонных приложений экосистемы [RealWorld](https://github.com/gothinkster/realworld).

Приложение полностью соответствует [официальной спецификации RealWorld API](https://gothinkster.github.io/realworld/docs/specs/backend-specs/introduction), поэтому его можно использовать с любым совместимым фронтендом из [каталога RealWorld](https://codebase.show/projects/realworld).

---

## О проекте RealWorld

[RealWorld](https://github.com/gothinkster/realworld) — это образовательный проект, в котором одно и то же приложение (социальная платформа для публикации статей) реализовано на десятках различных технологий: React, Vue, Angular, Laravel, Django, Spring и многих других.

Главная идея — показать, как выглядит «настоящее» приложение среднего уровня сложности на разных стеках, и при этом все реализации **взаимозаменяемы**, потому что следуют единой спецификации API.

Полезные ссылки:

- [Демо Conduit](https://demo.realworld.io) — готовый фронтенд, который можно подключить к этому API
- [Список фронтендов RealWorld](https://codebase.show/projects/realworld?category=frontend)
- [Список бэкендов RealWorld](https://codebase.show/projects/realworld?category=backend)
- [Аналог на Laravel](https://github.com/alexeymezenin/laravel-realworld-example-app) — та же логика, другой фреймворк

---

## Возможности

Приложение предоставляет полный набор функций социальной платформы для авторов:

| Функция | Описание |
|---------|----------|
| **Регистрация и вход** | Создание аккаунта, аутентификация по email и паролю, JWT-токены |
| **Профили пользователей** | Просмотр профиля, подписка и отписка от других авторов |
| **Статьи** | Создание, редактирование, удаление, просмотр списка и отдельной статьи |
| **Теги** | Привязка тегов к статьям, фильтрация по тегу |
| **Избранное** | Добавление и удаление статей в избранное |
| **Лента подписок** | Статьи только от авторов, на которых вы подписаны |
| **Комментарии** | Добавление и удаление комментариев к статьям |
| **Фильтрация** | По автору, тегу, избранному, с пагинацией |

---

## Стек технологий

| Компонент | Технология |
|-----------|------------|
| Язык | Ruby 3.1.3 |
| Фреймворк | Rails 7.0.4 (режим API) |
| База данных | SQLite 3 |
| Веб-сервер | Puma 5 |
| Аутентификация | JWT (`jwt` gem) + bcrypt |
| Хеширование паролей | `has_secure_password` (bcrypt) |

---

## Модель данных

```
User (пользователь)
├── username, email, password_digest, image, bio
├── has_many :articles
├── has_many :comments
└── has_and_belongs_to_many :followers / :following  (подписки)

Article (статья)
├── title, slug, description, body
├── belongs_to :user (автор)
├── has_and_belongs_to_many :tags
├── has_and_belongs_to_many :users  (избранное)
└── has_many :comments

Tag (тег)
└── name (уникальный)

Comment (комментарий)
├── body
├── belongs_to :article
└── belongs_to :user
```

Slug статьи генерируется автоматически из заголовка при сохранении (`title.parameterize`).

---

## Аутентификация

API использует **JSON Web Token (JWT)**.

1. При регистрации (`POST /api/users`) или входе (`POST /api/auth/login`) сервер возвращает токен.
2. Для защищённых эндпоинтов передавайте токен в заголовке:

```
Authorization: Token <ваш_jwt_токен>
```

3. Срок действия токена — **48 часов** (настраивается в `app/controllers/concerns/json_web_token.rb`).

Эндпоинты без авторизации: регистрация, вход, список статей, просмотр статьи, список тегов, просмотр профиля.

---

## API-эндпоинты

Все маршруты находятся под префиксом `/api`.

### Аутентификация и пользователи

| Метод | Путь | Описание | Авторизация |
|-------|------|----------|-------------|
| `POST` | `/api/users` | Регистрация нового пользователя | Нет |
| `POST` | `/api/auth/login` | Вход (email + password) | Нет |
| `GET` | `/api/user` | Текущий пользователь | Да |
| `PUT` | `/api/user` | Обновление профиля | Да |

### Профили

| Метод | Путь | Описание | Авторизация |
|-------|------|----------|-------------|
| `GET` | `/api/profiles/:username` | Профиль пользователя | Нет |
| `POST` | `/api/profiles/:username/follow` | Подписаться | Да |
| `DELETE` | `/api/profiles/:username/follow` | Отписаться | Да |

### Статьи

| Метод | Путь | Описание | Авторизация |
|-------|------|----------|-------------|
| `GET` | `/api/articles` | Список статей (с фильтрами) | Нет |
| `GET` | `/api/articles/feed` | Лента подписок | Да |
| `GET` | `/api/articles/:slug` | Одна статья | Нет |
| `POST` | `/api/articles` | Создать статью | Да |
| `PUT` | `/api/articles/:slug` | Обновить статью (только автор) | Да |
| `DELETE` | `/api/articles/:slug` | Удалить статью (только автор) | Да |
| `POST` | `/api/articles/:slug/favorite` | Добавить в избранное | Да |
| `DELETE` | `/api/articles/:slug/favorite` | Убрать из избранного | Да |

**Параметры фильтрации для `GET /api/articles`:**

- `tag` — фильтр по тегу
- `author` — фильтр по имени автора (username)
- `favorited` — статьи, добавленные в избранное указанным пользователем
- `limit` и `offset` — пагинация

### Комментарии

| Метод | Путь | Описание | Авторизация |
|-------|------|----------|-------------|
| `GET` | `/api/articles/:slug/comments` | Комментарии к статье | Да |
| `POST` | `/api/articles/:slug/comments` | Добавить комментарий | Да |
| `DELETE` | `/api/articles/:slug/comments/:id` | Удалить комментарий | Да |

### Теги

| Метод | Путь | Описание | Авторизация |
|-------|------|----------|-------------|
| `GET` | `/api/tags` | Список всех тегов | Нет |

---

## Требования

Перед запуском убедитесь, что установлены:

- **Ruby 3.1.3** — рекомендуется использовать [rbenv](https://github.com/rbenv/rbenv) или [rvm](https://rvm.io/)
- **Bundler** — менеджер зависимостей Ruby (`gem install bundler`)
- **SQLite 3** — обычно уже есть в macOS и большинстве Linux-дистрибутивов

Проверить версии:

```bash
ruby -v    # должно быть ruby 3.1.3
bundle -v
sqlite3 --version
```

---

## Установка и запуск

### 1. Клонирование репозитория

```bash
git clone https://github.com/alexeymezenin/ruby-on-rails-realworld-example-app
cd ruby-on-rails-realworld-example-app
```

> Если вы работаете с форком или локальной копией — перейдите в папку вашего проекта.

### 2. Установка зависимостей

```bash
bundle install
```

Команда установит все gems из `Gemfile`: Rails, Puma, SQLite, JWT, bcrypt и другие.

### 3. Подготовка базы данных

Создайте базу данных и примените миграции:

```bash
rails db:create
rails db:migrate
```

При необходимости можно загрузить тестовые данные:

```bash
rails db:seed
```

### 4. Запуск сервера

```bash
rails server
```

По умолчанию API доступен по адресу:

```
http://127.0.0.1:3000
```

Для запуска на другом порту:

```bash
rails server -p 4000
```

---

## Примеры запросов

### Регистрация

```bash
curl -X POST http://127.0.0.1:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "user": {
      "username": "jake",
      "email": "jake@jake.jake",
      "password": "jakejake"
    }
  }'
```

### Вход

```bash
curl -X POST http://127.0.0.1:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "jake@jake.jake",
    "password": "jakejake"
  }'
```

### Список статей

```bash
curl http://127.0.0.1:3000/api/articles
```

### Создание статьи (с токеном)

```bash
curl -X POST http://127.0.0.1:3000/api/articles \
  -H "Content-Type: application/json" \
  -H "Authorization: Token <ваш_токен>" \
  -d '{
    "article": {
      "title": "Как я учил Rails",
      "description": "Заметки новичка",
      "body": "Rails — отличный фреймворк...",
      "tagList": ["rails", "ruby", "обучение"]
    }
  }'
```

### Список тегов

```bash
curl http://127.0.0.1:3000/api/tags
```

---

## Запуск тестов

В проекте есть набор тестов на Minitest:

```bash
rails test
```

Тесты покрывают модели (`User`, `Article`, `Comment`, `Tag`) и контроллеры.

---

## Структура проекта

```
app/
├── controllers/
│   ├── application_controller.rb   # Базовый контроллер, JWT-авторизация
│   ├── authentication_controller.rb
│   ├── articles_controller.rb
│   ├── comments_controller.rb
│   ├── profiles_controller.rb
│   ├── tags_controller.rb
│   ├── users_controller.rb
│   └── concerns/
│       └── json_web_token.rb       # Кодирование/декодирование JWT
├── models/
│   ├── user.rb
│   ├── article.rb
│   ├── comment.rb
│   └── tag.rb
config/
├── routes.rb                       # Маршруты API
├── database.yml                    # Настройки SQLite
└── initializers/
    └── cors.rb                     # CORS (по умолчанию отключён)
db/
├── migrate/                        # Миграции базы данных
└── schema.rb                       # Текущая схема БД
test/                               # Тесты
```

---

## Подключение фронтенда

Чтобы использовать этот API с фронтендом Conduit (React, Vue, Angular и т.д.):

1. Запустите Rails-сервер на `http://127.0.0.1:3000`.
2. В настройках фронтенда укажите базовый URL API: `http://127.0.0.1:3000/api`.
3. При необходимости включите CORS в `config/initializers/cors.rb` — раскомментируйте блок `Rack::Cors` и укажите домен вашего фронтенда (например, `http://localhost:4200`).

> **Примечание:** gem `rack-cors` в `Gemfile` закомментирован. Для работы с отдельным фронтендом на другом порту его нужно раскомментировать и перезапустить сервер.

---

## Переменные окружения

| Переменная | Описание | Значение по умолчанию |
|------------|----------|----------------------|
| `RAILS_MAX_THREADS` | Размер пула соединений с БД | `5` |
| `RAILS_ENV` | Окружение (`development`, `test`, `production`) | `development` |

---

## Лицензия

Проект распространяется под лицензией, указанной в файле [LICENSE](LICENSE).

---

## Скрипт `app/sum.rb`

Вспомогательный Ruby-скрипт, который **складывает два числа** и возвращает их сумму.

**Пример:**

```
3 + 7  →  10
```

### Как это работает

1. Функция `sum(a, b)` принимает два аргумента и возвращает их сумму (`a + b`).
2. При запуске файла напрямую скрипт читает два числа из аргументов командной строки (`ARGV[0]` и `ARGV[1]`).
3. Аргументы преобразуются в числа с плавающей точкой (`to_f`) и результат выводится в консоль.

### Использование из кода

```ruby
require_relative 'app/sum'

sum(3, 7)    # => 10
sum(2.5, 4)  # => 6.5
```

### Запуск из командной строки

```bash
ruby app/sum.rb 3 7
# => 10.0
```

Первый аргумент — первое число, второй — второе. Можно передавать целые и дробные значения.

---

## Скрипт `app/reverse_words.rb`

Вспомогательный Ruby-скрипт, который **переворачивает буквы внутри каждого слова** строки. Порядок слов и пробелы между ними сохраняются.

**Пример:**

```
АЛИНА СУПЕР  →  АНИЛА РЕПУС
```

### Как это работает

1. Строка разбивается на слова по пробелам (`split`).
2. Каждое слово переворачивается посимвольно (`reverse`).
3. Слова снова объединяются в одну строку через пробел (`join(' ')`).

Функция `reverse_words` корректно обрабатывает кириллицу и другие Unicode-символы.

### Использование из кода

```ruby
require_relative 'app/reverse_words'

reverse_words('АЛИНА СУПЕР')  # => "АНИЛА РЕПУС"
reverse_words('hello world')   # => "olleh dlrow"
```

### Запуск из командной строки

```bash
ruby app/reverse_words.rb АЛИНА СУПЕР
# => АНИЛА РЕПУС
```

Все аргументы после имени файла склеиваются в одну строку, поэтому можно передавать фразу из нескольких слов без кавычек.

---

## Полезные команды Rails

```bash
rails routes          # Показать все маршруты
rails console         # Интерактивная консоль (IRB) с доступом к моделям
rails db:reset        # Пересоздать БД и применить миграции + seeds
rails db:rollback     # Откатить последнюю миграцию
```
