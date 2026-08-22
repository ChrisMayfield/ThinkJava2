# java-runner embeds

Minimal HTML for iframe embeds (e.g. WordPress strips inline `<script>` in post bodies).

## Collatz example

**WordPress:** Custom HTML block with an iframe. WordPress is not blocking scripts inside the iframe — if you only see static code, java-runner failed to load (check Network in devtools).

Site URL is **chrismayfield**.github.io (not chrisamayfield).

### iframe (after deploy to gh-pages `embed/`)

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

### Alternate iframe src

```html
src="https://raw.githack.com/ChrisMayfield/ThinkJava2/master/quarto/embed/collatz-conjecture.html"
```

`raw.githubusercontent.com` alone does not render as HTML in an iframe.
