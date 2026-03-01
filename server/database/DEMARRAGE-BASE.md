# Mise en place de la base — commandes à lancer

## 1. Une seule fois : installer PostgreSQL et créer la base

### Si PostgreSQL n’est pas installé
- Télécharge : https://www.postgresql.org/download/windows/
- Installe (garder le port **5432** et note le mot de passe de l’utilisateur `postgres`).

### Créer la base et les tables (depuis la racine du projet)

**PowerShell (Windows), à la racine du repo :**

Si `psql` n’est pas dans le PATH, utilise le chemin complet (ex. PostgreSQL 17) :

```powershell
# Créer la base
& "C:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres -c "CREATE DATABASE cinema_reservation;"

# Appliquer le schéma (toutes les tables)
& "C:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres -d cinema_reservation -f server/database/schema.sql
```

Ou si `psql` est dans le PATH : `psql -U postgres -c "CREATE DATABASE cinema_reservation;"` puis `psql -U postgres -d cinema_reservation -f server/database/schema.sql`

*(Remplace `postgres` par ton utilisateur PostgreSQL si différent. On te demandera le mot de passe si besoin.)*

### Configurer le mot de passe côté serveur

1. Copie le fichier des mots de passe :
   ```powershell
   copy server\config\passwords.yaml.example server\config\passwords.yaml
   ```
2. Ouvre `server/config/passwords.yaml` et remplace `VOTRE_MOT_DE_PASSE_POSTGRESQL` par le vrai mot de passe de l’utilisateur `postgres`.

---

## 2. À chaque fois : commandes selon la situation

### Tu démarres juste le serveur (aucun changement de schéma)
```powershell
cd server
dart run bin/main.dart
```

### Il y a eu un changement de structure (tables/colonnes) dans le dépôt — lancer les migrations
```powershell
cd server
dart run bin/main.dart --apply-migrations
```
*(Puis laisse tourner le serveur ou relance avec la commande ci-dessus.)*

### Alternative : réappliquer tout le schéma SQL à la main
*(Utile si tu n’utilises pas les migrations Serverpod et que le schéma a été mis à jour.)*
```powershell
psql -U postgres -d cinema_reservation -f server/database/schema.sql
```
*(Attention : si les tables existent déjà, certains `CREATE TABLE` peuvent être ignorés grâce à `IF NOT EXISTS` ; pour des changements de colonnes, il faut parfois des scripts de migration à part.)*

---

## 3. Après chaque `git pull` (important pour toute l’équipe)

Quand quelqu’un a modifié le schéma de la base (nouvelles tables, colonnes, etc.) et a poussé sur le repo, **tout le monde** doit mettre à jour sa base locale après un `git pull` :

```powershell
cd server
dart run bin/main.dart --apply-migrations
```

Ensuite tu peux lancer le serveur normalement (`dart run bin/main.dart`).  
**Règle :** après un pull, lance les migrations pour récupérer les changements de la base.

---

## 4. Récap rapide

| Quand ? | Commande |
|--------|----------|
| **Première fois** | Créer la base + `psql ... -f server/database/schema.sql` + configurer `passwords.yaml` |
| **Après un `git pull`** (pour récupérer les changements de la base) | `cd server` puis `dart run bin/main.dart --apply-migrations` |
| **Lancer le serveur au quotidien** | `cd server` puis `dart run bin/main.dart` |

---

*Rappel :* `development.yaml` est déjà configuré pour `localhost`, base `cinema_reservation`, utilisateur `postgres`. Seul le mot de passe dans `passwords.yaml` est à mettre à jour chez toi.
