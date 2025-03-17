-- MenuScan Database Schema for Supabase

-- Enable the necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Profiles table to store additional user information
CREATE TABLE public.profiles (
  id UUID REFERENCES auth.users NOT NULL PRIMARY KEY,
  username TEXT UNIQUE,
  full_name TEXT,
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Secure RLS policies for profiles
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own profile" 
  ON public.profiles 
  FOR SELECT 
  USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile" 
  ON public.profiles 
  FOR UPDATE 
  USING (auth.uid() = id);

-- Function to handle new user creation
CREATE OR REPLACE FUNCTION public.handle_new_user() 
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, username, full_name, avatar_url)
  VALUES (new.id, new.email, '', '');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger for new user signup
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Menus table to store user menus
CREATE TABLE public.menus (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES auth.users NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  restaurant_name TEXT,
  restaurant_location TEXT,
  restaurant_phone TEXT,
  restaurant_logo_url TEXT,
  template_id TEXT,
  qr_code_url TEXT,
  qr_code_color TEXT DEFAULT '#6366F1',
  qr_code_bg_color TEXT DEFAULT '#FFFFFF',
  include_logo BOOLEAN DEFAULT true,
  include_name BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Secure RLS policies for menus
ALTER TABLE public.menus ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own menus" 
  ON public.menus 
  FOR SELECT 
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own menus" 
  ON public.menus 
  FOR INSERT 
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own menus" 
  ON public.menus 
  FOR UPDATE 
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own menus" 
  ON public.menus 
  FOR DELETE 
  USING (auth.uid() = user_id);

-- Menu categories table
CREATE TABLE public.menu_categories (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  menu_id UUID REFERENCES public.menus ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Secure RLS policies for menu_categories
ALTER TABLE public.menu_categories ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own menu categories" 
  ON public.menu_categories 
  FOR SELECT 
  USING (auth.uid() IN (
    SELECT user_id FROM public.menus WHERE id = menu_id
  ));

CREATE POLICY "Users can insert their own menu categories" 
  ON public.menu_categories 
  FOR INSERT 
  WITH CHECK (auth.uid() IN (
    SELECT user_id FROM public.menus WHERE id = menu_id
  ));

CREATE POLICY "Users can update their own menu categories" 
  ON public.menu_categories 
  FOR UPDATE 
  USING (auth.uid() IN (
    SELECT user_id FROM public.menus WHERE id = menu_id
  ));

CREATE POLICY "Users can delete their own menu categories" 
  ON public.menu_categories 
  FOR DELETE 
  USING (auth.uid() IN (
    SELECT user_id FROM public.menus WHERE id = menu_id
  ));

-- Menu items table
CREATE TABLE public.menu_items (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  menu_id UUID REFERENCES public.menus ON DELETE CASCADE NOT NULL,
  category_id UUID REFERENCES public.menu_categories ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  price DECIMAL(10, 2),
  image_url TEXT,
  is_available BOOLEAN DEFAULT true,
  is_featured BOOLEAN DEFAULT false,
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Secure RLS policies for menu_items
ALTER TABLE public.menu_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own menu items" 
  ON public.menu_items 
  FOR SELECT 
  USING (auth.uid() IN (
    SELECT user_id FROM public.menus WHERE id = menu_id
  ));

CREATE POLICY "Users can insert their own menu items" 
  ON public.menu_items 
  FOR INSERT 
  WITH CHECK (auth.uid() IN (
    SELECT user_id FROM public.menus WHERE id = menu_id
  ));

CREATE POLICY "Users can update their own menu items" 
  ON public.menu_items 
  FOR UPDATE 
  USING (auth.uid() IN (
    SELECT user_id FROM public.menus WHERE id = menu_id
  ));

CREATE POLICY "Users can delete their own menu items" 
  ON public.menu_items 
  FOR DELETE 
  USING (auth.uid() IN (
    SELECT user_id FROM public.menus WHERE id = menu_id
  ));

-- Create indexes for better performance
CREATE INDEX idx_menus_user_id ON public.menus(user_id);
CREATE INDEX idx_menu_categories_menu_id ON public.menu_categories(menu_id);
CREATE INDEX idx_menu_items_menu_id ON public.menu_items(menu_id);
CREATE INDEX idx_menu_items_category_id ON public.menu_items(category_id);