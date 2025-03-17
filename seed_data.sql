-- Seed data for testing the MenuScan application
-- Note: Replace 'your-user-id' with an actual auth.users.id value from your Supabase project

-- Sample menu 1: Italian Restaurant
INSERT INTO public.menus (
  id, 
  user_id, 
  title, 
  description, 
  restaurant_name, 
  restaurant_location, 
  restaurant_phone, 
  template_id
) VALUES (
  '11111111-1111-1111-1111-111111111111'::uuid, 
  'your-user-id'::uuid, 
  'Bella Italia Menu', 
  'Authentic Italian cuisine', 
  'Bella Italia', 
  '123 Main Street, New York', 
  '(555) 123-4567', 
  'classic'
);

-- Categories for Italian Restaurant
INSERT INTO public.menu_categories (
  id, 
  menu_id, 
  name, 
  description, 
  display_order
) VALUES 
(
  '22222222-2222-2222-2222-222222222201'::uuid, 
  '11111111-1111-1111-1111-111111111111'::uuid, 
  'Appetizers', 
  'Start your meal with our delicious appetizers', 
  1
),
(
  '22222222-2222-2222-2222-222222222202'::uuid, 
  '11111111-1111-1111-1111-111111111111'::uuid, 
  'Pasta', 
  'Homemade pasta dishes', 
  2
),
(
  '22222222-2222-2222-2222-222222222203'::uuid, 
  '11111111-1111-1111-1111-111111111111'::uuid, 
  'Pizza', 
  'Wood-fired authentic Italian pizza', 
  3
),
(
  '22222222-2222-2222-2222-222222222204'::uuid, 
  '11111111-1111-1111-1111-111111111111'::uuid, 
  'Desserts', 
  'Sweet endings to your meal', 
  4
);

-- Menu items for Italian Restaurant
INSERT INTO public.menu_items (
  id, 
  menu_id, 
  category_id, 
  name, 
  description, 
  price, 
  is_featured, 
  display_order
) VALUES 
-- Appetizers
(
  '33333333-3333-3333-3333-333333333301'::uuid, 
  '11111111-1111-1111-1111-111111111111'::uuid, 
  '22222222-2222-2222-2222-222222222201'::uuid, 
  'Bruschetta', 
  'Toasted bread topped with tomatoes, garlic, and basil', 
  8.99, 
  true, 
  1
),
(
  '33333333-3333-3333-3333-333333333302'::uuid, 
  '11111111-1111-1111-1111-111111111111'::uuid, 
  '22222222-2222-2222-2222-222222222201'::uuid, 
  'Caprese Salad', 
  'Fresh mozzarella, tomatoes, and basil with balsamic glaze', 
  10.99, 
  false, 
  2
),
-- Pasta
(
  '33333333-3333-3333-3333-333333333303'::uuid, 
  '11111111-1111-1111-1111-111111111111'::uuid, 
  '22222222-2222-2222-2222-222222222202'::uuid, 
  'Spaghetti Carbonara', 
  'Spaghetti with egg, cheese, pancetta, and black pepper', 
  16.99, 
  true, 
  1
),
(
  '33333333-3333-3333-3333-333333333304'::uuid, 
  '11111111-1111-1111-1111-111111111111'::uuid, 
  '22222222-2222-2222-2222-222222222202'::uuid, 
  'Fettuccine Alfredo', 
  'Fettuccine in a rich, creamy Parmesan sauce', 
  15.99, 
  false, 
  2
),
-- Pizza
(
  '33333333-3333-3333-3333-333333333305'::uuid, 
  '11111111-1111-1111-1111-111111111111'::uuid, 
  '22222222-2222-2222-2222-222222222203'::uuid, 
  'Margherita', 
  'Tomato sauce, mozzarella, and basil', 
  14.99, 
  true, 
  1
),
(
  '33333333-3333-3333-3333-333333333306'::uuid, 
  '11111111-1111-1111-1111-111111111111'::uuid, 
  '22222222-2222-2222-2222-222222222203'::uuid, 
  'Pepperoni', 
  'Tomato sauce, mozzarella, and pepperoni', 
  16.99, 
  false, 
  2
),
-- Desserts
(
  '33333333-3333-3333-3333-333333333307'::uuid, 
  '11111111-1111-1111-1111-111111111111'::uuid, 
  '22222222-2222-2222-2222-222222222204'::uuid, 
  'Tiramisu', 
  'Coffee-soaked ladyfingers with mascarpone cream', 
  8.99, 
  true, 
  1
),
(
  '33333333-3333-3333-3333-333333333308'::uuid, 
  '11111111-1111-1111-1111-111111111111'::uuid, 
  '22222222-2222-2222-2222-222222222204'::uuid, 
  'Cannoli', 
  'Crispy pastry shells filled with sweet ricotta cream', 
  7.99, 
  false, 
  2
);

-- Sample menu 2: Café
INSERT INTO public.menus (
  id, 
  user_id, 
  title, 
  description, 
  restaurant_name, 
  restaurant_location, 
  restaurant_phone, 
  template_id
) VALUES (
  '11111111-1111-1111-1111-111111111112'::uuid, 
  'your-user-id'::uuid, 
  'Urban Café Menu', 
  'Fresh coffee and light meals', 
  'Urban Café', 
  '456 Oak Avenue, Chicago', 
  '(555) 789-0123', 
  'modern'
);

-- Categories for Café
INSERT INTO public.menu_categories (
  id, 
  menu_id, 
  name, 
  description, 
  display_order
) VALUES 
(
  '22222222-2222-2222-2222-222222222205'::uuid, 
  '11111111-1111-1111-1111-111111111112'::uuid, 
  'Coffee', 
  'Premium coffee drinks', 
  1
),
(
  '22222222-2222-2222-2222-222222222206'::uuid, 
  '11111111-1111-1111-1111-111111111112'::uuid, 
  'Sandwiches', 
  'Fresh, made-to-order sandwiches', 
  2
),
(
  '22222222-2222-2222-2222-222222222207'::uuid, 
  '11111111-1111-1111-1111-111111111112'::uuid, 
  'Pastries', 
  'Freshly baked goods', 
  3
);

-- Menu items for Café
INSERT INTO public.menu_items (
  id, 
  menu_id, 
  category_id, 
  name, 
  description, 
  price, 
  is_featured, 
  display_order
) VALUES 
-- Coffee
(
  '33333333-3333-3333-3333-333333333309'::uuid, 
  '11111111-1111-1111-1111-111111111112'::uuid, 
  '22222222-2222-2222-2222-222222222205'::uuid, 
  'Espresso', 
  'Rich, concentrated coffee', 
  3.99, 
  true, 
  1
),
(
  '33333333-3333-3333-3333-333333333310'::uuid, 
  '11111111-1111-1111-1111-111111111112'::uuid, 
  '22222222-2222-2222-2222-222222222205'::uuid, 
  'Cappuccino', 
  'Espresso with steamed milk and foam', 
  4.99, 
  false, 
  2
),
-- Sandwiches
(
  '33333333-3333-3333-3333-333333333311'::uuid, 
  '11111111-1111-1111-1111-111111111112'::uuid, 
  '22222222-2222-2222-2222-222222222206'::uuid, 
  'Avocado Toast', 
  'Sourdough toast with avocado, cherry tomatoes, and microgreens', 
  9.99, 
  true, 
  1
),
(
  '33333333-3333-3333-3333-333333333312'::uuid, 
  '11111111-1111-1111-1111-111111111112'::uuid, 
  '22222222-2222-2222-2222-222222222206'::uuid, 
  'Chicken Pesto Panini', 
  'Grilled chicken, pesto, mozzarella, and roasted red peppers', 
  11.99, 
  false, 
  2
),
-- Pastries
(
  '33333333-3333-3333-3333-333333333313'::uuid, 
  '11111111-1111-1111-1111-111111111112'::uuid, 
  '22222222-2222-2222-2222-222222222207'::uuid, 
  'Croissant', 
  'Buttery, flaky pastry', 
  3.99, 
  true, 
  1
),
(
  '33333333-3333-3333-3333-333333333314'::uuid, 
  '11111111-1111-1111-1111-111111111112'::uuid, 
  '22222222-2222-2222-2222-222222222207'::uuid, 
  'Blueberry Muffin', 
  'Moist muffin loaded with fresh blueberries', 
  4.99, 
  false, 
  2
);