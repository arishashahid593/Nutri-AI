USE gwnutri_ai_db;

-- 1. Users Table (Mobile app user accounts)
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2. User Profiles Table (Dietary restrictions, allergies, and language preference)
CREATE TABLE user_profiles (
    profile_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    preferred_language ENUM('en', 'ur') DEFAULT 'en', -- English or Urdu support
    health_goals TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 3. User Allergies / Dietary Restrictions Table
CREATE TABLE user_allergies (
    allergy_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    allergen_name VARCHAR(100) NOT NULL, -- e.g., Milk, Nuts, Gluten
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 4. Ingredient Knowledge Base & Alias Resolution Table (Resolves technical codes / E-numbers)
CREATE TABLE ingredient_knowledge_base (
    ingredient_id INT AUTO_INCREMENT PRIMARY KEY,
    canonical_name VARCHAR(150) NOT NULL UNIQUE, -- Standard name e.g., Sodium Benzoate
    alternative_name VARCHAR(150), -- E-numbers or synonyms e.g., E211
    category VARCHAR(100), -- Preservative, Sweetener, etc.
    allergen_relationship VARCHAR(100), -- Associated allergen if any
    description_en TEXT, -- Explanation in English
    description_ur TEXT -- Explanation in Urdu
);

-- 5. Products Table (Scanned food products metadata)
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    brand VARCHAR(100),
    barcode VARCHAR(50) UNIQUE,
    raw_ocr_text TEXT, -- Complete raw text extracted via OCR
    scanned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6. Product Ingredients Mapping Table
CREATE TABLE product_ingredients (
    product_ingredient_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    ingredient_id INT, -- Linked to Knowledge Base if recognized
    extracted_ingredient_text VARCHAR(150) NOT NULL, -- Exact text from package
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (ingredient_id) REFERENCES ingredient_knowledge_base(ingredient_id) ON DELETE SET NULL
);

-- 7. Product Claims Table (Front-of-package marketing and health claims extracted via OCR/NLP)
CREATE TABLE product_claims (
    claim_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    claim_text TEXT NOT NULL,
    claim_category ENUM('Environmental', 'Health', 'Specific/substantive', 'Vague/symbolic', 'Verification-required') NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- 8. Scan History & Transparency Reports Table (Final analysis results for users)
CREATE TABLE scan_reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    environmental_score DECIMAL(5, 2), -- Environmental Transparency Score
    health_score DECIMAL(5, 2), -- Health Claim Transparency Score
    ingredient_score DECIMAL(5, 2), -- Ingredient Transparency Score
    overall_transparency_score DECIMAL(5, 2), -- Overall Score
    consistency_assessment TEXT, -- Claim-Label Consistency Assessment summary
    conflict_warnings TEXT, -- Flagged allergy/dietary conflicts
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- 9. User Medical Conditions Table (For common diseases and health issues)
CREATE TABLE user_medical_conditions (
    condition_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    condition_name VARCHAR(100) NOT NULL, -- e.g., Diabetes, Hypertension, etc.
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);