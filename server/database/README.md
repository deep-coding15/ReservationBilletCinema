# Base de données - Reservation Billet Cinema

- **Fichier des tables :** `server/database/schema.sql`

## Base cloud (Neon / Supabase)

1. Créer une base sur [Neon](https://neon.tech) ou [Supabase](https://supabase.com).
2. Dans le SQL Editor, coller le contenu de `schema.sql` et exécuter.
3. Dans `server/config/development.yaml` : mettre à jour `database` (host, port: 5432, name, user). Le mot de passe se met dans `server/config/passwords.yaml` (section `development.database`). Ne pas commiter `passwords.yaml`.

## PostgreSQL local

```bash
createdb -U postgres cinema_reservation
psql -U postgres -d cinema_reservation -f server/database/schema.sql
```

Puis adapter `server/config/development.yaml` (port 5432) et `server/config/passwords.yaml` (mot de passe DB).
