# Ruby Rules

**Experience** - Advanced

## General

- **Language** - Even if the conversation language is different (e.g., Turkish), everything within the code (comments,
  variables, file names) is **always in English**.
- **Level** - Tailor explanations to the specified experience level; skip basics.
- **Simplicity** - Avoid verbose code unless it improves readability.
- **Ruby Version** - **Always** use modern Ruby syntax/version if Ruby version is unspecified. **Do not** write code in legacy syntax.

## Style

- **Rails Style Guide** - Follow [Rails Style Guide](https://github.com/rubocop/rails-style-guide).
- **Indent** - 2 spaces. Double quotes (`"`) for strings.
- **Methods** - Use `def foo = ...` syntax for **single line** methods.
- **Order**
  1. `include`/`extend`
  2. Constants (Alpha)
  3. `attr_*` (Alpha)
  4. `initialize`
  5. `public` methods (Alpha)
  6. `private` methods (Alpha)

- **Private Indent** - Indent `private` methods **2 levels (4 spaces)**.

  ```ruby
  class Foo
    def public_method; end

    private

      # 2 levels deep
      def private_method; end
  end
  ```

- **Alphabetize** arrays, dicts, assignments, and methods if order is irrelevant.
- **Align** consecutive assignments around the `=` operator.
  
  ```ruby
  # Aligned & Alphabetical
  bar                = 5
  i                  = 3
  long_variable_name = 8
  
  # Alphabetical Elements
  LIST = %i[A B C].freeze
  ```

- **Comments** - Code should be self-documenting. If you need a comment to explain WHAT the code does, consider
  refactoring to make it clearer. Unacceptable comments:
  - Comments that repeat what code does
  - Commented-out code (delete it)
  - Obvious comments ("increment counter")
  - Comments instead of good naming
  - Comments about updates to old code (e.g. `# now supports xyz`)
