# Integrating MenuScan with Supabase

This guide walks through the steps to connect your MenuScan application with the Supabase backend.

## Prerequisites

1. A Supabase account and project
2. The database schema set up using the `schema.sql` file

## Step 1: Set Up Environment Variables

Create a `.env` file in the root of your MenuScan project with the following variables:

```
EXPO_PUBLIC_SUPABASE_URL=https://your-project-id.supabase.co
EXPO_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
```

Replace `your-project-id` and `your-anon-key` with your actual Supabase project details.

## Step 2: Install Required Packages

Install the necessary Supabase packages:

```bash
npx expo install @supabase/supabase-js
npx expo install react-native-url-polyfill
```

## Step 3: Initialize Supabase Client

Create a file `utils/supabase.ts` with the following content:

```typescript
import 'react-native-url-polyfill/auto';
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL as string;
const supabaseAnonKey = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY as string;

export const supabase = createClient(supabaseUrl, supabaseAnonKey);
```

## Step 4: Create an Auth Context

Create a file `context/AuthContext.tsx` to manage authentication:

```typescript
import React, { createContext, useState, useEffect, useContext } from 'react';
import { supabase } from '../utils/supabase';
import { Session, User } from '@supabase/supabase-js';

type AuthContextType = {
  user: User | null;
  session: Session | null;
  initialized: boolean;
  signUp: (email: string, password: string) => Promise<any>;
  signIn: (email: string, password: string) => Promise<any>;
  signOut: () => Promise<any>;
  loading: boolean;
};

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider = ({ children }: { children: React.ReactNode }) => {
  const [user, setUser] = useState<User | null>(null);
  const [session, setSession] = useState<Session | null>(null);
  const [initialized, setInitialized] = useState(false);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    // Check for active session
    supabase.auth.getSession().then(({ data: { session } }) => {
      setSession(session);
      setUser(session?.user ?? null);
      setInitialized(true);
    });

    // Listen for auth changes
    const { data: { subscription } } = supabase.auth.onAuthStateChange(
      (_event, session) => {
        setSession(session);
        setUser(session?.user ?? null);
      }
    );

    return () => subscription.unsubscribe();
  }, []);

  const signUp = async (email: string, password: string) => {
    setLoading(true);
    try {
      const { data, error } = await supabase.auth.signUp({
        email,
        password,
      });
      if (error) throw error;
      return data;
    } catch (error) {
      throw error;
    } finally {
      setLoading(false);
    }
  };

  const signIn = async (email: string, password: string) => {
    setLoading(true);
    try {
      const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password,
      });
      if (error) throw error;
      return data;
    } catch (error) {
      throw error;
    } finally {
      setLoading(false);
    }
  };

  const signOut = async () => {
    setLoading(true);
    try {
      const { error } = await supabase.auth.signOut();
      if (error) throw error;
    } catch (error) {
      throw error;
    } finally {
      setLoading(false);
    }
  };

  return (
    <AuthContext.Provider
      value={{
        user,
        session,
        initialized,
        signUp,
        signIn,
        signOut,
        loading,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};
```

## Step 5: Create a Menu Context

Create a file `context/MenuContext.tsx` to manage menu operations:

```typescript
import React, { createContext, useState, useContext } from 'react';
import { supabase } from '../utils/supabase';
import { useAuth } from './AuthContext';

type MenuItem = {
  id?: string;
  name: string;
  description?: string;
  price?: number;
  category_id?: string;
};

type Menu = {
  id?: string;
  title: string;
  items: MenuItem[];
  categories: string[];
};

type MenuContextType = {
  currentMenu: Menu | null;
  savedMenus: Menu[];
  setCurrentMenu: React.Dispatch<React.SetStateAction<Menu | null>>;
  saveMenu: () => Promise<string | undefined>;
  loadSavedMenus: () => Promise<void>;
  loadMenu: (id: string) => Promise<void>;
  deleteSelectedMenu: (id: string) => Promise<void>;
};

const MenuContext = createContext<MenuContextType | undefined>(undefined);

export const MenuProvider = ({ children }: { children: React.ReactNode }) => {
  const [currentMenu, setCurrentMenu] = useState<Menu | null>(null);
  const [savedMenus, setSavedMenus] = useState<Menu[]>([]);
  const { user } = useAuth();

  const saveMenu = async () => {
    if (!currentMenu || !user) return;

    try {
      let menuId = currentMenu.id;

      // If we have an existing menu, update it
      if (menuId) {
        const { error } = await supabase
          .from('menus')
          .update({
            title: currentMenu.title,
            updated_at: new Date(),
          })
          .eq('id', menuId);

        if (error) throw error;
      } 
      // Otherwise create a new menu
      else {
        const { data, error } = await supabase
          .from('menus')
          .insert({
            user_id: user.id,
            title: currentMenu.title,
          })
          .select();

        if (error) throw error;
        menuId = data[0].id;
      }

      return menuId;
    } catch (error) {
      console.error('Error saving menu:', error);
      throw error;
    }
  };

  const loadSavedMenus = async () => {
    if (!user) return;

    try {
      const { data, error } = await supabase
        .from('menus')
        .select(`
          *,
          menu_categories (
            *,
            menu_items (*)
          )
        `)
        .eq('user_id', user.id)
        .order('updated_at', { ascending: false });

      if (error) throw error;

      // Transform data to match our Menu type
      const menus = data.map((menu) => {
        const categories = menu.menu_categories || [];
        const items = categories.flatMap((cat) => cat.menu_items || []);
        
        return {
          id: menu.id,
          title: menu.title,
          categories: categories.map((cat) => cat.name),
          items: items.map((item) => ({
            id: item.id,
            name: item.name,
            description: item.description,
            price: item.price,
            category_id: item.category_id,
          })),
        };
      });

      setSavedMenus(menus);
    } catch (error) {
      console.error('Error loading menus:', error);
      throw error;
    }
  };

  const loadMenu = async (id: string) => {
    try {
      const { data, error } = await supabase
        .from('menus')
        .select(`
          *,
          menu_categories (
            *,
            menu_items (*)
          )
        `)
        .eq('id', id)
        .single();

      if (error) throw error;

      const categories = data.menu_categories || [];
      const items = categories.flatMap((cat) => cat.menu_items || []);
      
      setCurrentMenu({
        id: data.id,
        title: data.title,
        categories: categories.map((cat) => cat.name),
        items: items.map((item) => ({
          id: item.id,
          name: item.name,
          description: item.description,
          price: item.price,
          category_id: item.category_id,
        })),
      });

    } catch (error) {
      console.error('Error loading menu:', error);
      throw error;
    }
  };

  const deleteSelectedMenu = async (id: string) => {
    try {
      const { error } = await supabase
        .from('menus')
        .delete()
        .eq('id', id);

      if (error) throw error;
      
      // Update local state
      setSavedMenus(savedMenus.filter(menu => menu.id !== id));
    } catch (error) {
      console.error('Error deleting menu:', error);
      throw error;
    }
  };

  return (
    <MenuContext.Provider
      value={{
        currentMenu,
        savedMenus,
        setCurrentMenu,
        saveMenu,
        loadSavedMenus,
        loadMenu,
        deleteSelectedMenu,
      }}
    >
      {children}
    </MenuContext.Provider>
  );
};

export const useMenu = () => {
  const context = useContext(MenuContext);
  if (context === undefined) {
    throw new Error('useMenu must be used within a MenuProvider');
  }
  return context;
};
```

## Step 6: Wrap Your App with Providers

Update your `app/_layout.tsx` file to include the providers:

```typescript
import { AuthProvider } from '../context/AuthContext';
import { MenuProvider } from '../context/MenuContext';

export default function RootLayout() {
  // ... existing code

  return (
    <ThemeProvider value={DefaultTheme}>
      <AuthProvider>
        <MenuProvider>
          {/* Your existing app structure */}
        </MenuProvider>
      </AuthProvider>
    </ThemeProvider>
  );
}
```

## Step 7: Create Protected Routes

Implement navigation logic to redirect unauthenticated users to the login page:

```typescript
// In your main navigation or _layout.tsx
import { useAuth } from '../context/AuthContext';
import { useEffect } from 'react';
import { useRouter, useSegments } from 'expo-router';

function useProtectedRoute(user) {
  const segments = useSegments();
  const router = useRouter();

  useEffect(() => {
    const inAuthGroup = segments[0] === '(auth)';

    if (!user && !inAuthGroup) {
      // Redirect to the login page if not logged in
      router.replace('/login');
    } else if (user && inAuthGroup) {
      // Redirect to the home page if logged in
      router.replace('/');
    }
  }, [user, segments]);
}

// Use this hook in your root layout
const { user, initialized } = useAuth();
useProtectedRoute(user);

// Show a loading screen until authentication is initialized
if (!initialized) {
  return <LoadingScreen />;
}
```

## Step 8: Test the Integration

1. Run your MenuScan app
2. Register a new user
3. Create a menu and save it
4. Verify the data is stored in your Supabase database

## Troubleshooting

- If you encounter CORS issues, make sure your Supabase project has the correct URL settings in the API settings.
- Check the authentication settings in your Supabase dashboard to ensure email/password sign-up is enabled.
- Verify that your environment variables are correctly set up and accessible in your application.

## Next Steps

1. Implement storage for menu images
2. Add social authentication methods
3. Create admin features for restaurant owners
4. Implement analytics to track menu views