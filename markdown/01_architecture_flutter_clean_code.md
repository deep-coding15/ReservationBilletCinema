# 📱 Architecture Flutter – Clean Architecture + Feature First

Ce document explique la structure de projet Flutter suivante :
```scss
lib/
├── config/
│    ├── routes/
│    └── theme/
├── core/
│    ├── error/
│    ├── network/
│    ├── usecases/
│    └── util/
├── features/
│    └── auth/
│         ├── data/
│         │    ├── data_sources/
│         │    ├── models/
│         │    └── repository/
│         ├── domain/
│         │    ├── entities/
│         │    ├── repository/
│         │    └── usecases/
│         └── presentation/
│              ├── bloc/
│              ├── pages/
│              └── widgets/
└── main.dart
```
Cette architecture combine :

- Feature First
- Clean Architecture
- Séparation stricte des responsabilités
- Scalabilité
- Testabilité

---

## 1️⃣ main.dart
Rôle: 
- Point d’entrée de l’application.

Responsabilités
- Initialiser les dépendances
- Configurer les routes
- Injecter les providers / blocs
- Lancer runApp()

---

## 2️⃣ config/

Contient la configuration globale de l’application.

### 📂 config/routes/
Rôle

- Gestion centralisée de la navigation.

Exemple

- AppRouter

- RouteGenerator

- GoRouter config

Pourquoi ?

Évite de mélanger la logique métier avec la navigation.

### 📂 config/theme/
Rôle

- Gestion du thème global :

    - Couleurs
    - Typographie
    - Dark mode
    - Styles communs

Pourquoi ?

- Uniformité visuelle + maintenance simple.

---

## 3️⃣ core/

Contient tout ce qui est partagé par toute l’application.

**⚠️ Aucune logique métier spécifique ici.**

### 📂 core/error/

Gestion des erreurs globales :

- Exceptions

- Failures (pattern Clean Architecture)

- Error mapping API → Domain

Exemple :

- class ServerException implements Exception {}
- class ServerFailure extends Failure {}

### 📂 core/network/

Gestion réseau commune :

- Dio client

- Interceptors

- Headers

- Gestion token

- Check connexion internet

### 📂 core/usecases/

Classe abstraite de base pour tous les usecases :

```scss
abstract class UseCase<Type, Params> {
    Future<Type> call(Params params);
}
```

Permet d’uniformiser toute la couche Domain.

### 📂 core/util/

Helpers globaux :

- Validators

- Formatters

- Constants

- Extensions Dart

---

## 4️⃣ features/

Architecture Feature First.

Chaque fonctionnalité est indépendante :

- auth

- booking

- movies

- profile

- payment

- etc.

Chaque feature contient ses 3 couches Clean Architecture.

**🔵 Clean Architecture – Principe Fondamental**

3 couches strictement séparées :

Presentation  →  Domain  →  Data

Dépendances toujours orientées vers le centre :

* Presentation dépend de Domain

* Data dépend de Domain

* Domain ne dépend de rien

📌 Exemple : feature/auth/

---

### 1️⃣ domain/

Cœur métier pur.

- Ne dépend PAS de Flutter.
- Ne dépend PAS d’API.
- Ne dépend PAS de Firebase.

#### 📂 entities/
Rôle

Représentation métier pure.
```scss
class User {
    final String id;
    final String email;
}
```

⚠️ Pas de JSON ici.
⚠️ Pas d’annotation.

#### 📂 repository/

Contrat abstrait.

```scss
abstract class AuthRepository {
    Future<User> login(String email, String password);
}
```

Ici on définit CE QUE l’on veut faire.
Pas COMMENT on le fait.

#### 📂 usecases/

Chaque action métier est un usecase.

```scss
class LoginUseCase {
    final AuthRepository repository;
    
    LoginUseCase(this.repository);
    
    Future<User> call(LoginParams params) {
        return repository.login(params.email, params.password);
    }
}
```

🎯 1 UseCase = 1 action métier.

---

### 2️⃣ data/

Couche technique.

**Ici on implémente le repository.**

#### 📂 data_sources/

Source réelle des données :

- RemoteDataSource (API)

- LocalDataSource (SQLite, Hive)

- FirebaseDataSource

#### 📂 models/

Représentation technique des données.

```scss
class UserModel extends User {
    factory UserModel.fromJson(Map<String, dynamic> json) {}
    Map<String, dynamic> toJson() {}
}
```

⚠️ Les Models étendent les Entities.

#### 📂 repository/

Implémentation concrète du repository :

```scss
class AuthRepositoryImpl implements AuthRepository {
    final AuthRemoteDataSource remoteDataSource;
    
    @override
    Future<User> login(...) {
        return remoteDataSource.login(...);
    }
}

```

---

### 3️⃣ presentation/

Partie Flutter UI.

#### 📂 bloc/

Gestion d’état.

Peut être :

- Bloc

- Cubit

- Riverpod

- Provider

Responsabilités :

- Appeler les usecases

- Gérer loading / error / success

- Exposer un state

#### 📂 pages/

Écrans complets :

- LoginPage

- RegisterPage

#### 📂 widgets/

Composants réutilisables :

- CustomTextField

- AuthButton

- ErrorWidget

🔁 Cycle complet d’une action

Exemple : Login
```scss
User clique →
Page →
Bloc →
UseCase →
Repository (interface) →
RepositoryImpl →
RemoteDataSource →
API →
Retour →
Bloc →
State →
UI update
```

---

🎯 Pourquoi cette architecture ?

✅ 1. Scalabilité

Ajout facile de nouvelles features.

✅ 2. Testabilité

On peut mocker :

- Repository

- Usecases

- DataSources

✅ 3. Séparation claire des responsabilités

UI ≠ logique métier ≠ accès données

✅ 4. Maintenabilité

Projet professionnel production-ready.

🔥 Différence avec architecture classique MVC
```scss
MVC	                     Clean Architecture
Couplage fort	         Couplage faible
Difficile à tester	     Très testable
Mélange UI & logique     Séparation stricte
Peu scalable	         Très scalable
```

📦 Comment ajouter une nouvelle feature ?

Exemple : booking

```scss
features/
booking/
data/
domain/
presentation/
```

Même structure que auth.

Architecture modulaire.

🧠 Résumé Conceptuel

```scss
main.dart → Bootstrap

config → configuration globale

core → commun à toute l’app

features → logique métier par module

domain → cerveau

data → technique

presentation → interface
```