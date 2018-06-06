# baldrick
[![GitHub license](https://img.shields.io/badge/license-Apache%202-blue.svg?style=flat-square)](https://raw.githubusercontent.com/BlazingMammothGames/baldrick/master/LICENSE) [![Build Status](https://img.shields.io/travis/BlazingMammothGames/baldrick.svg?style=flat-square)](https://travis-ci.org/BlazingMammothGames/baldrick)

> So, in other words, the Turnip Surprise would be… a turnip.

![baldrick the turnip](https://i.imgur.com/Zo6jWUd.gif)

## Documentation

### Manual

This package is my own [ECS](http://gameprogrammingpatterns.com/component.html), initially based very heavily on [edge](https://github.com/fponticelli/edge), now based more on [specs](https://github.com/slide-rs/specs), but really just built the way I want to interact with things.

The key features of this library include:

* "Pure" ECS philosophy—all data is stored in `components`, all logic is written in `processors`
  * `entities` are just ID numbers
  * `phases` group `processors` together in logical units (updating, rendering, etc)
  * `processors` process lists of entities which match their interests provided by `views`
  * `universes` store `entities` and provide `views` with updates on those entities
* Component data is stored in `storage` containers which can be chosen based on their usage pattern (mostly how common each component is).
* Just about fully [behaviour-tested](https://en.wikipedia.org/wiki/Behavior-driven_development): https://travis-ci.org/BlazingMammothGames/baldrick
* Profiling built in
  * Add the define `-D profiling` to your build process to enable profiling individual processors & overall phases
  * Still experimental, but seems to work without issue
* Integration with [turnip](https://github.com/BlazingMammothGames/turnip)
  * _turnip_ is an addon for [Blender](https://www.blender.org/) which allows you to use Blender as a level editor (so you can be lazy and not write your own level editor / rely on writing levels in code or text)
  * Add the define `-D turnip` to generate a `turnip.json` file, which contains definitions of all the components and processors available in your game. _turnip_ then can load the `turnip.json` to enable game-specific level editing in Blender!
  * This feature is still very much under development (as is _turnip_ itself), so ¯\\\_(ツ)\_/¯

Why "baldrick"? Well, I tend to use an ECS in a lot / most of my projects (as a lot / most of my projects with Haxe are game-related), so this library could be called my [dogsbody](https://en.wikipedia.org/wiki/Dogsbody), so I named it after the [best dogsbody in all of history](https://en.wikipedia.org/wiki/Baldrick).

### API

API documentation is available here: https://blazingmammothgames.github.io/baldrick/

### Benchmarking

| Target | Entity Creation (Vectors) (µs/entity) | Processor Time (µ/iteration) |
|--------|--------------------------------------:|-----------------------------:|
| JS     |                                 12.20 |                       148.10 |
| HL     |                                 38.11 |                      1280.96 |
| CPP    |                                  3.75 |                       683.69 |
