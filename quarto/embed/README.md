# java-runner embeds

Minimal HTML for iframe embeds (e.g. WordPress strips inline `<script>` in post bodies).

Site URL is **chrismayfield**.github.io (not chrisamayfield).

**WordPress:** Custom HTML block with an iframe. If you only see static code, java-runner failed to load (check Network in devtools).

## Collatz program (ch06)

```html
<iframe
  src="https://chrismayfield.github.io/ThinkJava2/embed/collatz-conjecture.html"
  width="100%"
  height="420"
  style="border:1px solid #e0e0e0;border-radius:6px;"
  loading="lazy"
  title="Collatz conjecture — interactive Java">
</iframe>
```

## String REPL (ch06)

```html
<iframe
  src="https://chrismayfield.github.io/ThinkJava2/embed/fruit-charat-repl.html"
  width="100%"
  height="320"
  style="border:1px solid #e0e0e0;border-radius:6px;"
  loading="lazy"
  title="String charAt — Java REPL">
</iframe>
```

Both embeds use light-mode console/REPL styling. Source files live in `quarto/embed/`.
