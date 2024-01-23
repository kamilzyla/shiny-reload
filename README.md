# Shiny (auto) reloading

This repository contains some experiments around (auto) reloading of Shiny apps.
Each example can be run with `shiny::runApp(name)`.
Check the code comments and read the text below to learn what the example demonstrates.

## `reload`

Whenever the timestamp of `app.R` is updated,
Shiny will source it again the next time the app page is loaded or refreshed.
This is a default behavior which does not require any additional setup;
it different from automatic reloading enabled with `options(shiny.autoreload = TRUE)`.

Try these steps:

1. Run the example with `shiny::runApp("reload")`.
Observe the output in the console.
2. Open the app in the browser.
3. Modify the `"Hello!"` message in `app.R`.
4. Refresh the page.

## `wrap`

The default reloading behavior showed in the `reload` example has some quirks.
See the [investigate reloading](https://github.com/Appsilon/rhino/issues/157#issuecomment-1169925583)
issue in Rhino for an explanation of this example.

## `full`

This example demonstrates a complete solution for proper (auto) reloading in Shiny.
It simulates a setup used by Rhino.
