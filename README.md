# Flappy Ponix
'플래피 포닉스(Flappy Ponix)'는 🐤 플래피 버드(Flappy Bird)를 모티브로 개발한 🕹 미니 게임 Flutter Package 입니다.

- 포스텍 마스코트인 포닉스(PONIX)와 학교 이미지를 도트화하여 캐릭터, 배경으로 사용함
- 외부 게임 엔진을 사용하지 않고 순수 Flutter(Dart)로만 개발함
- '포식이(Posikyi)' 🥚 이스터에그 용도로 개발함

## Installing

### 1. Depend on it

Add this to your package's pubspec.yaml file:

```yaml
flappy_ponix:
  git:
    url: https://gitlab.com/poapper-inc/flappy-ponix.git
```

### 2. Install it

You can install packages from the command line:

```sh
$ flutter pub get
```

### 3. Import it

Now in your Dart code, you can use:

```dart
import 'package:flappy_ponix/main.dart';
```

## Example

You just call the widget `FlappyPonix()`.

```dart
Scaffold(
    body: FlappyPonix(),
    ...
),
```
