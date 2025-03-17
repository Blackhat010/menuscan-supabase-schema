# MenuScan Supabase Database Schema

This repository contains the database schema and SQL setup files for the MenuScan application, which uses Supabase as its backend.

## Database Structure

The schema includes the following tables:

1. **profiles** - Additional user information that extends the default Supabase auth.users table
2. **menus** - Stores information about digital menus created by users
3. **menu_categories** - Categories for menu items (e.g., Appetizers, Main Course, Desserts)
4. **menu_items** - Individual dishes/items on the menu

## Row Level Security (RLS)

All tables are secured with Row Level Security policies to ensure users can only:
- View, modify, or delete their own data
- Safely interact with the database through the Supabase client

## Installation Instructions

To set up this database schema in your Supabase project:

1. Navigate to the SQL Editor in your Supabase dashboard
2. Copy the contents of `schema.sql` from this repository
3. Paste and execute the SQL in the editor

## Relationship Diagram

```
auth.users
    ↓
profiles
    ↓
menus
    ↓
 ┌─────┴─────┐
 ↓           ↓
menu_categories   menu_items
     ↑
     └─────────→ menu_items
```

## API Routes

After setting up the database, you can use the following Supabase client methods to interact with your data:

### Authentication
```javascript
// Sign up
const { user, error } = await supabase.auth.signUp({
  email: 'user@example.com',
  password: 'password123'
})

// Sign in
const { user, error } = await supabase.auth.signIn({
  email: 'user@example.com',
  password: 'password123'
})

// Sign out
const { error } = await supabase.auth.signOut()
```

### Menus
```javascript
// Get all menus for the current user
const { data, error } = await supabase
  .from('menus')
  .select('*')

// Get a single menu with its categories and items
const { data, error } = await supabase
  .from('menus')
  .select(`
    *,
    menu_categories (
      *,
      menu_items (*)
    )
  `)
  .eq('id', 'menu_id')
  .single()

// Create a new menu
const { data, error } = await supabase
  .from('menus')
  .insert([
    {
      title: 'My Restaurant Menu',
      restaurant_name: 'Restaurant Name',
      user_id: 'user_id'
    }
  ])
```

## Support

For issues or questions regarding the database schema, please open an issue in this repository.