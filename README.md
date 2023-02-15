# 🦅 event-app-frontend

## 👩‍💻 Development

### ⛽ Prerequisites

- To build the project you will need 🦅 Flutter and platform-specific SDKs. Please follow the comprehensive instructions in the [Flutter docs](https://docs.flutter.dev/get-started/install).
- You will need Docker or a setup for building [`event-app-backend`](https://github.com/kontentbuzdygan/event-app-backend), if you want to host it locally.

### 🛠️ Setup

1. 🍺 🥃 🍷 🍸
2. 📥 Check out this repository.
3. 📝 Copy [`.env.example`](.env.example) to `.env` and fill in the configuration.
   - `API_URL` needs to point to a running instance of [`event-app-backend`](https://github.com/kontentbuzdygan/event-app-backend) with the API path appended to it (`/api/v0`). You can either host the backend locally (follow the Docker instructions on the backend repo) or use the publicly hosted `https://event-app-backend.hop.sh/api/v0`.
4. 🏃‍♀️ `flutter run`

## 🗄️ Folder structure

- [📂 `lib/`](lib) contains the actual application code.
  - [📂 `features/`](lib/features) contains UI code and is organized by features.
  - [📂 `api/`](lib/api) contains services interfacing with the backend.
- 📜 `.env` contains app configuration which can be customized by any developer to suit the needs of their dev environment, and should not be included in source control. [📜 `.env.example`](.env.example) provides an example for new developers and should not be filled in with actual data.
- 📂 The following directories contain platform-specific native code generated by Flutter. You will probably never need to modify their files and should always commit them as-is. Though please make sure not to commit unnecessary files, e.g. workspace config files generated by XCode. When in doubt, try to rename/delete them and see if 🏃‍♀️ `flutter run` still succeeds.

  ```
  android/
  ios/
  linux/
  macos/
  web/
  windows/
  ```

## 🤼 Contributing

Branches related to tickets from the issue tracker should be named `username/ticket-id`, e.g. `john-doe/eve-123`.

1. When publishing a branch, open a PR for it, self-assign it and mark it as `draft`.
2. When your changes are complete and your PR passes all CI checks ✅, remove the `draft` label and request a review 👀.
3. After getting an approval ✅, feel free to squash 🫂 and merge 📥
4. 🤑 💸 💰 📈
