# FUND

## System Overview

### Problem Statement  
Users struggle with budgeting due to psychological friction: savings feel restrictive and restrictive budgets fail. Current finance apps lack engagement and fail to reward productive spending decisions.

### Solution  
Guilt-Free FUNd gamifies budgeting by:  
1. Assigning points to "productive" expenses (groceries, transport)  
2. Converting points into a "guilt-free" luxury fund  
3. Controlling impulse purchases via wishlists with cooldown periods  
4. Creating social accountability through leaderboards

### Core Value Proposition  
Transform budgeting from "spending less" → "earning more through smart choices"

---

## Inputs & Outputs

### System Inputs

#### User Actions  
| Input | Description | Type |  
|-------|-------------|------|  
| **Login/Register** | Email + password authentication | String, Email |  
| **Log Expense** | Amount, category, date, description | Decimal, Enum, Date, String, File |  
| **Add Wishlist Item** | Item name, estimated price, cooldown days | String, Decimal, Integer |  
| **Wishlist Decision** | Buy / Skip / Delete wishlist item | Enum |  
| **Add Friend** | Friend email or user code | Email/UUID |  
| **Update Settings** | Exchange rate, category weights, subscriptions | Decimal, Map&lt;Category, Decimal&gt; |  
| **Filter Expenses** | Date range, category, sort order | Date, Enum, Enum |

#### System Events  
| Event | Source | Data |  
|-------|--------|------|  
| **Subscription Renewal** | Scheduled job | user_id, subscription_id, cost |  
| **Wishlist Cooldown Expiry** | Scheduled job | wishlist_item_id |  
| **Daily Leaderboard Recalculation** | Scheduled job | User scores |

### System Outputs

#### User-Facing  
| Output | Medium | Description |  
|--------|--------|-------------|  
| **Dashboard** | Web/Mobile | Points balance, luxury fund, recent expenses, leaderboard rank |  
| **Monthly Pie Chart** | Web/Mobile | Expense breakdown by category (%) |  
| **Wishlist Countdown** | Web/Mobile | Real-time timer for cooldown periods |  
| **Leaderboard** | Web/Mobile | Friend rankings, top spenders, savers |  
| **Notifications** | Push/Email | Subscription alerts, wishlist reminders |

#### System-Generated  
| Output | Format | Purpose |  
|--------|--------|---------|  
| **API Responses** | JSON | REST endpoints return structured data |  
| **Authentication Tokens** | JWT | Stateless session management |  
---

## Feature Requirements

### Core Features

#### 1. Authentication & User Management  
- Email/password registration with validation  
- JWT-based session management  
- Password reset via email (Supabase Auth)  
- User profile with avatar support ( via library )

#### 2. Expense Logging  
- Quick-add: amount + category  
- Full form: amount, category, date, description, receipt photo  
- Real-time point calculation (instant feedback)

#### 3. Point System  
- Automatic calculation: `amount × category_weight × base_rate`  
- Category weights user-configurable (default: groceries=1.5, transport=1.2, coffee=0.5)  
- Base rate: £0.10 = 1 point (user-settable)  
- Points stored in ledger

#### 4. Luxury Fund  
- Virtual balance tracked separately from points  
- Conversion rate user-settable (e.g., 10 points = £1 luxury)  
- Manual conversion UI  
- Linked to wishlist purchases

#### 5. Wishlist  
- Add item with estimated price + custom cooldown (3-30 days)  
- Real-time countdown timer (Supabase real-time)  
- Status tracking: active → cooldown → purchased/saved  
- Skip purchase → credit to "saved" balance + bonus points (5% of estimated price)

#### 6. Monthly Expense Analytics  
- Pie chart: percentage breakdown by category  
- Summary stats: total, average, highest category  
- Trend view: last 3 months comparison

#### 7. Expense History  
- Table with: date, description, amount, category, points earned  
- Filters: date range, category, sort by date/amount/points  
- Search by description

#### 8. Leaderboard  
- Friend rankings by total points earned (current month)  
- Filter: this month, last 30 days, all-time  
- Your rank position  
- Opt-in privacy controls

#### 9. Friend System  
- Add friend by email or unique user code  
- Friend requests with accept/reject  
- View friend's public stats (points, rank, top categories)  
- Block friend

#### 10. Settings  
- Exchange rate adjustment  
- Category weight customization  
- Friend management  
- Notification preferences  
- Data export (GDPR)

### Additional Features

#### 11. Subscription Tracking  
- Add subscription: name, cost, renewal date  
- Monthly cost visualization (subscription "bleed")  
- Renewal alerts (3 days before)  
- Auto-cancel option

#### 12. Achievements  
- Badges: "First Expense", "100 Points", "Avoided 5 Impulses"  
- Share achievements on leaderboard

#### 13. Advanced Analytics  
- Spending trends (month-over-month)  
- Category spending forecast  
- "Savings" goal progress

---

## Technology Stack

### Frontend Layer

| Component | Technology | Rationale |  
|-----------|-----------|-----------|  
| **Framework** | React 18 | Component reusability, state management, large community |  
| **Styling** | Tailwind CSS | Rapid iteration, responsive design, dark mode support |  
| **Routing** | React Router v6 | Nested routes, URL state management |  
| **UI Components** | Shadcn, DiceBear | Accessible, unstyled components with Tailwind |

&nbsp;

### Backend Layer

| Component | Technology | Rationale |  
|-----------|-----------|-----------|  
| **Framework** | FastAPI | Async-first, automatic OpenAPI docs, type hints for team collaboration |  
| **ORM** | SQLAlchemy | Async support with `databases` library, query builders |  
| **Database** | PostgreSQL via Supabase | Relational model, real-time subscriptions, JSON support for flexible schemas |  
| **Authentication** | Supabase Auth + JWT | Managed service, OAuth2 integration, email verification |  
| **Caching** | Redis | Session storage, leaderboard scores, rate limiting |  
| **Task Queue** | Celery + Redis | Async jobs: subscription alerts, daily leaderboard recalc |  
| **Logging** | Python logging + Sentry | Error tracking in production |

&nbsp;

---

## Data Model & Storage

### Database Schema (PostgreSQL)

```sql  
-- ====== AUTHENTICATION & USERS ======

CREATE TABLE users (  
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),  
  email VARCHAR(255) UNIQUE NOT NULL,  
  created_at TIMESTAMP DEFAULT NOW(),  
  updated_at TIMESTAMP DEFAULT NOW(),  
  avatar_url TEXT,  
  is_public BOOLEAN DEFAULT FALSE, -- Leaderboard visibility  
  -- Points system  
  total_points DECIMAL(12,2) DEFAULT 0,  
  luxury_points_spent DECIMAL(12,2) DEFAULT 0,  
  -- Settings  
  exchange_rate DECIMAL(5,2) DEFAULT 10.00, -- points per £1 luxury  
  base_point_rate DECIMAL(4,2) DEFAULT 0.10, -- £ per 1 point  
  -- Metadata  
  country_code VARCHAR(2) DEFAULT 'GB'  
);

-- ====== EXPENSE CATEGORIES & WEIGHTS ======

CREATE TABLE categories (  
  id SERIAL PRIMARY KEY,  
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,  
  name VARCHAR(50) NOT NULL,  
  emoji VARCHAR(5),  
  point_weight DECIMAL(3,2) DEFAULT 1.00,  
  color_hex VARCHAR(7),  
  created_at TIMESTAMP DEFAULT NOW(),  
  UNIQUE(user_id, name)  
);

-- ====== EXPENSES & POINT LEDGER ======

CREATE TABLE expenses (  
  id SERIAL PRIMARY KEY,  
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,  
  category_id INT NOT NULL REFERENCES categories(id),  
  amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),  
  description TEXT,  
  date DATE NOT NULL DEFAULT CURRENT_DATE,  
  receipt_url TEXT, -- Supabase Storage URL  
  points_earned DECIMAL(10,2) NOT NULL,  
  created_at TIMESTAMP DEFAULT NOW(),  
  INDEX(user_id, date),  
  INDEX(user_id, category_id)  
);

CREATE TABLE points_ledger (  
  id BIGSERIAL PRIMARY KEY,  
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,  
  transaction_type ENUM('expense_logged', 'wishlist_saved', 'bonus', 'conversion') NOT NULL,  
  amount DECIMAL(12,2) NOT NULL,  
  reference_id INT, -- Links to expense_id or wishlist_id  
  created_at TIMESTAMP DEFAULT NOW(),  
  INDEX(user_id, created_at)  
);

-- ====== WISHLIST ======

CREATE TABLE wishlist (  
  id SERIAL PRIMARY KEY,  
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,  
  item_name VARCHAR(100) NOT NULL,  
  estimated_price DECIMAL(10,2) NOT NULL CHECK (estimated_price > 0),  
  added_date TIMESTAMP DEFAULT NOW(),  
  cooldown_days INT DEFAULT 7 CHECK (cooldown_days BETWEEN 3 AND 30),  
  status ENUM('active', 'cooldown', 'purchased', 'saved', 'deleted') DEFAULT 'active',  
  saved_amount DECIMAL(10,2) DEFAULT 0,  
  bonus_points_awarded DECIMAL(10,2) DEFAULT 0,  
  decision_date TIMESTAMP, -- When user bought/saved/deleted  
  created_at TIMESTAMP DEFAULT NOW(),  
  updated_at TIMESTAMP DEFAULT NOW(),  
  INDEX(user_id, status, cooldown_date)  
);

-- ====== SUBSCRIPTIONS ======

CREATE TABLE subscriptions (  
  id SERIAL PRIMARY KEY,  
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,  
  name VARCHAR(100) NOT NULL,  
  monthly_cost DECIMAL(10,2) NOT NULL CHECK (monthly_cost > 0),  
  renewal_date DATE NOT NULL,  
  category_id INT REFERENCES categories(id),  
  next_alert_date DATE,  
  is_active BOOLEAN DEFAULT TRUE,  
  created_at TIMESTAMP DEFAULT NOW(),  
  INDEX(user_id, renewal_date)  
);

-- ====== LEADERBOARD & SOCIAL ======

CREATE TABLE friends (  
  id SERIAL PRIMARY KEY,  
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,  
  friend_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,  
  status ENUM('pending', 'accepted', 'blocked') DEFAULT 'pending',  
  created_at TIMESTAMP DEFAULT NOW(),  
  CHECK (user_id != friend_id),  
  UNIQUE(user_id, friend_id)  
);

CREATE TABLE leaderboard_scores (  
  id SERIAL PRIMARY KEY,  
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,  
  period ENUM('weekly', 'monthly', 'alltime') NOT NULL,  
  score DECIMAL(12,2) NOT NULL,  
  rank INT,  
  calculated_at TIMESTAMP DEFAULT NOW(),  
  UNIQUE(user_id, period),  
  INDEX(period, score DESC)  
);  
```

### Data Relationships Diagram

```  
users (1)  
  ├─── (1:M) categories  
  ├─── (1:M) expenses → categories (M:1)  
  ├─── (1:M) points_ledger  
  ├─── (1:M) wishlist  
  ├─── (1:M) subscriptions  
  ├─── (1:M) friends (user_id → friend_id)  
  ├─── (1:M) friends (friend_id ← user_id)  
  └─── (1:M) leaderboard_scores  
```

---

## System Architecture

### High-Level Architecture Diagram

```  
┌─────────────────────────────────────────────────────────────┐  
│ PRESENTATION LAYER │  
│ ┌──────────────┬──────────────┬──────────────┐ │  
│ │ Dashboard │ Wishlist │ Expenses │ Profile │  
│ │ (React) │ (React) │ (React) │ (React) │  
│ └──────────────┴──────────────┴──────────────┘ │  
└──────────────────────────┬──────────────────────────────────┘  
                           │ HTTP/WebSocket  
┌──────────────────────────▼──────────────────────────────────┐  
│ API LAYER (FastAPI) │  
│ ┌──────────────┬──────────────┬──────────────┐ │  
│ │ Auth API │ Expense API │ Friend API │ Other │  
│ │ JWT, OAuth │ CRUD, Point │ Leaderboard │ Endpoints │  
│ │ │ Calc │ │ │  
│ └──────────────┴──────────────┴──────────────┘ │  
└──────────────────────────┬──────────────────────────────────┘  
                           │  
         ┌─────────────────┼─────────────────┐  
         │ │ │  
┌────────▼────────┐ ┌─────▼──────┐ ┌──────▼────────┐  
│ PostgreSQL DB │ │ Redis │ │ File Storage │  
│ (Supabase) │ │ (Caching) │ │ (Supabase) │  
└─────────────────┘ └────────────┘ └───────────────┘  
         │  
┌────────▼────────────────────────────────────────┐  
│ BACKGROUND JOBS │  
│ - Daily leaderboard calculation │  
│ - Subscription renewal alerts │  
│ - Wishlist cooldown notifications │  
└─────────────────────────────────────────────────┘  
```

## Page Structure & UI Layout

### 0. Authentication Page

**Route:** `/auth` (redirects from `/` if not logged in)

**Layout:**  
```  
┌─────────────────────────────────────┐  
│ │  
│ GUILT-FREE FUNd │  
│ 💰 Earn Points, Save Money │  
│ │  
│ ┌─────────────────────────────────┐│  
│ │ Email: [____________] ││  
│ │ Password: [____________] ││  
│ │ ││  
│ │ [Login] [Sign Up] ││  
│ │ ││  
│ │ Or sign in with Google ││  
│ └─────────────────────────────────┘│  
│ │  
│ Don't have account? Sign up │  
│ Forgot password? │  
│ │  
└─────────────────────────────────────┘  
```

**Elements:**  
- Email input (validation: RFC 5322)  
- Password input (8+ chars, special character suggested)  
- Remember me checkbox  
- Forgot password link → email reset flow  
- Sign up toggle → registration form  
- OAuth buttons (Google, Apple)

---

### 1. Main Dashboard Tab

**Route:** `/dashboard` (default after login)

**Layout (Mobile-First):**  
```  
┌──────────────────────────┐  
│ ← Guilt-Free FUNd ☰ │ (Header with menu)  
├──────────────────────────┤  
│ │  
│ 💰 POINTS BALANCE │  
│ ┌────────────────────┐ │  
│ │ 2,450 points │ │  
│ │ (£245 luxury fund) │ │  
│ └────────────────────┘ │  
│ │  
│ ┌────────────────────┐ │  
│ │ [+ LOG EXPENSE] │ │ (Primary CTA)  
│ │ (Large, green) │ │  
│ └────────────────────┘ │  
│ │  
│ 📊 THIS MONTH │  
│ ┌────────────────────┐ │  
│ │ Spent: £487 │ │  
│ │ Points: 524 │ │  
│ │ Avg/day: £15.70 │ │  
│ └────────────────────┘ │  
│ │  
│ 👥 LEADERBOARD │  
│ ┌────────────────────┐ │  
│ │ 1. Sarah (5,230) │ │  
│ │ 2. Tom (4,890) │ │  
│ │ 3. YOU (2,450) ← │ │ (Highlighted)  
│ │ 4. Emma (2,100) │ │  
│ │ [VIEW FULL] │ │  
│ └────────────────────┘ │  
│ │  
│ 📝 RECENT EXPENSES │  
│ ┌────────────────────┐ │  
│ │ Tesco £45.23 │ │  
│ │ Coffee £4.50 │ │  
│ │ Bus £1.75 │ │  
│ │ [VIEW ALL] │ │  
│ └────────────────────┘ │  
│ │  
└──────────────────────────┘  
      [💰] [📋] [🛒] [👤] (Bottom tab bar)  
```

**Desktop Layout (Sidebar):**  
```  
┌─────────────────────────────────────────┐  
│ Guilt-Free FUNd [Search] [Profile] ☰ │  
├─────────────────────────────────────────┤  
│ │ │  
│ [Home] │ ┌──────────────────┐ │  
│ [Wishes]│ │ 💰 POINTS │ │  
│ [Expns] │ │ 2,450 / £245 │ │  
│ [Prof] │ └──────────────────┘ │  
│ │ │  
│ │ [+ LOG EXPENSE] │  
│ │ Large green button │  
│ │ │  
│ │ 📊 Monthly Stats │  
│ │ Spent: £487, Points: 524 │  
│ │ │  
│ │ 👥 Top Friends │  
│ │ 1. Sarah 2. Tom 3. You │  
│ │ │  
│ │ 📝 Recent (5 items) │  
│ │ │  
└─────────────────────────────────────────┘  
```

**Key Elements:**

| Element | Type | Interaction |  
|---------|------|-------------|  
| **Points Balance** | Display | Real-time updates via WebSocket |  
| **Luxury Fund** | Display | Calculated from points (read-only) |  
| **Log Expense Button** | CTA | Opens modal/bottom sheet |  
| **Monthly Stats** | Card | Shows total spent, points earned, average/day |  
| **Leaderboard** | Card | Shows top 5 friends, user's rank, [View Full] link |  
| **Recent Expenses** | List | Shows last 5 expenses, [View All] link to Expenses tab |  
| **Notifications** | Badge | Red dot on bell icon if alerts pending |

---

### 2. Wishlist Tab

**Route:** `/wishlist`

**Layout:**  
```  
┌──────────────────────────┐  
│ Wishlist [+ Add]│ (Header with CTA)  
├──────────────────────────┤  
│ │  
│ 🎯 ACTIVE (1) │  
│ ┌────────────────────┐ │  
│ │ PlayStation 5 │ │  
│ │ Est: £449.99 │ │  
│ │ Added: 2 days ago │ │  
│ │ ⏳ Cooldown: 5d 3h│ │  
│ │ │ │  
│ │ [Delete] │ │  
│ └────────────────────┘ │  
│ │  
│ ⏱️ READY FOR DECISION (2)│  
│ ┌────────────────────┐ │  
│ │ Nintendo Switch │ │  
│ │ Est: £299.99 │ │  
│ │ Added: 8 days ago │ │  
│ │ │ │  
│ │ [💚 Save] [🛒 Buy] │ │  
│ └────────────────────┘ │  
│ ┌────────────────────┐ │  
│ │ Coffee Machine │ │  
│ │ Est: £120.00 │ │  
│ │ Added: 7 days ago │ │  
│ │ │ │  
│ │ [💚 Save] [🛒 Buy] │ │  
│ └────────────────────┘ │  
│ │  
│ 💰 SAVED (3) │  
│ ┌────────────────────┐ │  
│ │ ✓ Books Pack │ │  
│ │ Saved: £45.50 │ │  
│ │ Saved: 5 days ago │ │  
│ │ Bonus: +2.28 pts │ │  
│ │ │ │  
│ │ [Delete] │ │  
│ └────────────────────┘ │  
│ │  
└──────────────────────────┘  
```

**Modal: Add to Wishlist**  
```  
┌──────────────────────────┐  
│ Add Wishlist Item [X] │  
├──────────────────────────┤  
│ │  
│ Item Name: │  
│ [PlayStation 5______] │  
│ │  
│ Estimated Price: │  
│ £[449.99_________] │  
│ │  
│ Cooldown Period: │  
│ [7 days ▼] │ (Dropdown: 3-30)  
│ │  
│ [Add to Wishlist] │  
│ [Cancel] │  
│ │  
└──────────────────────────┘  
```

**Key Elements:**

| Element | Type | Interaction |  
|---------|------|-------------|  
| **Active Items** | Card List | Shows countdown timer (real-time) |  
| **Cooldown Timer** | Display | Updates every second via WebSocket |  
| **Ready for Decision** | Card List | Shows [Save] [Buy] buttons when cooldown expires |  
| **Saved Items** | Card List | Shows saved amount + bonus points |  
| **Delete Button** | Action | Removes item permanently |  
| **Add Button** | CTA | Opens form modal |

**Notifications:**  
- Push notification when cooldown expires  
- Email digest: "Your wishlist items are ready for decision"

---

### 3. Expenses Tab

**Route:** `/expenses`

**Layout:**  
```  
┌──────────────────────────┐  
│ Expenses [🔍][⋯] │ (Search + filter)  
├──────────────────────────┤  
│ │  
│ Filter Bar: │  
│ ┌────────────────────┐ │  
│ │ Date: This Month ▼ │ │  
│ │ Category: All ▼ │ │  
│ │ Sort: Date ▼ │ │  
│ └────────────────────┘ │  
│ │  
│ 📊 SUMMARY │  
│ Total: £487.20 │  
│ Count: 23 expenses │  
│ Average: £21.18 │  
│ │  
│ Pie Chart: │  
│ (Visual breakdown) │  
│ 🛒 Shopping 45% │  
│ 🥬 Groceries 30% │  
│ 🚌 Transport 15% │  
│ 🏠 Other 10% │  
│ │  
│ EXPENSE LIST │  
│ ┌────────────────────┐ │  
│ │ 2025-01-26 (Today) │ │  
│ │ Tesco £45.23│ │  
│ │ 🥬 Groceries +47pts │  
│ │ │ │  
│ │ 2025-01-25 │ │  
│ │ Starbucks £4.50│ │  
│ │ ☕ Coffee +2pts │ │  
│ │ │ │  
│ │ 2025-01-24 │ │  
│ │ Bus £1.75│ │  
│ │ 🚌 Transport +2pts │ │  
│ │ │ │  
│ │ [LOAD MORE] │ │  
│ └────────────────────┘ │  
│ │  
└──────────────────────────┘  
```

**Desktop View (Table):**  
```  
┌────────────────────────────────────────────┐  
│ Date │ Desc │ Category │ Amount │  
├────────────────────────────────────────────┤  
│ 2025-01-26│ Tesco │ Groceries│ £45.23│  
│ 2025-01-25│ Starbucks │ Coffee │ £4.50 │  
│ 2025-01-24│ Bus Fare │ Transport│ £1.75 │  
│ 2025-01-24│ Laundry │ Laundry │ £6.00 │  
│ 2025-01-23│ Waitrose │ Groceries│ £52.00│  
│ │ │ │ │  
└────────────────────────────────────────────┘  
```

**Key Elements:**

| Element | Type | Interaction |  
|---------|------|-------------|  
| **Date Filter** | Dropdown | This Month, Last 30 Days, Custom Range |  
| **Category Filter** | Multi-select | Filter by: Groceries, Transport, Shopping, etc. |  
| **Sort** | Dropdown | By: Date (desc), Amount (desc), Points (desc) |  
| **Pie Chart** | Visualization | Click slice to filter by category |  
| **Expense List** | Grouped by date | Grouped date headers (Today, Yesterday, etc.) |  
| **Expense Item** | Card/Row | Shows: date, description, category emoji, amount, points |

---

### 4. Profile Page

**Route:** `/profile`

**Layout (Scrollable):**  
```  
┌──────────────────────────┐  
│ Profile [✎]│ (Edit icon)  
├──────────────────────────┤  
│ │  
│ [👤 AVATAR] │  
│ [Change Avatar] │  
│ │  
│ USERNAME │  
│ [Your Name_________] │  
│ │  
│ EMAIL │  
│ user@example.com │  
│ │  
│ POINTS & BALANCES │  
│ ┌────────────────────┐ │  
│ │ Total Points: 2,450│ │  
│ │ Luxury Fund: £245 │ │  
│ │ Spent This Month: │ │  
│ │ £487.20 │ │  
│ └────────────────────┘ │  
│ │  
│ SPENDING SETTINGS │  
│ ┌────────────────────┐ │  
│ │ Exchange Rate: │ │  
│ │ [10 points = £1 ] │ │  
│ │ Base Rate: │ │  
│ │ [£0.10 per point] │ │  
│ │ │ │  
│ │ [UPDATE] │ │  
│ └────────────────────┘ │  
│ │  
│ CATEGORY WEIGHTS │  
│ ┌────────────────────┐ │  
│ │ 🛒 Shopping: 0.5x │ │  
│ │ 🥬 Groceries: 1.5x │ │  
│ │ 🚌 Transport: 1.2x │ │  
│ │ ☕ Coffee: 0.5x │ │  
│ │ [ADD CATEGORY] │ │  
│ │ [SAVE] │ │  
│ └────────────────────┘ │  
│ │  
│ FRIENDS │  
│ ┌────────────────────┐ │  
│ │ Sarah (+5,230 pts) │ │  
│ │ Tom (+4,890 pts) │ │  
│ │ Emma (+2,100 pts) │ │  
│ │ │ │  
│ │ [+ ADD FRIEND] │ │  
│ │ [VIEW ALL FRIENDS] │ │  
│ └────────────────────┘ │  
│ │  
│ PRIVACY & SECURITY │  
│ ┌────────────────────┐ │  
│ │ ☐ Public Profile │ │  
│ │ (Show on leaderb)│ │  
│ │ ☐ Friend Requests │ │  
│ │ (Allow auto-add) │ │  
│ │ │ │  
│ │ [MANAGE SESSIONS] │ │  
│ │ [DOWNLOAD DATA] │ │  
│ │ [DELETE ACCOUNT] │ │  
│ └────────────────────┘ │  
│ │  
│ [LOGOUT] │  
│ │  
└──────────────────────────┘  
```

**Modal: Add Friend**  
```  
┌──────────────────────────┐  
│ Add Friend [X] │  
├──────────────────────────┤  
│ │  
│ Find friend by: │  
│ [Email or Username___] │  
│ [Search] │  
│ │  
│ Results: │  
│ ☐ Sarah H. (5,230 pts) │  
│ ☐ Tom J. (4,890 pts) │  
│ │  
│ [Send Requests] │  
│ │  
└──────────────────────────┘  
```

**Key Elements:**

| Element | Type | Interaction |  
|---------|------|-------------|  
| **Avatar** | Image/Upload | Click to change avatar (Supabase Storage) |  
| **Username** | Input | Editable in edit mode |  
| **Points Display** | Card | Read-only summary |  
| **Exchange Rate** | Slider + Input | User-configurable (5-100 points per £) |  
| **Base Rate** | Input | User-configurable (default £0.10 per point) |  
| **Category Weights** | List + Inputs | Edit weights for each category (0.1 - 3.0x) |  
| **Friends List** | Card List | Shows friend score, [Remove] button |  
| **Add Friend Button** | CTA | Opens search/invite modal |  
| **Public Profile Toggle** | Checkbox | Controls leaderboard visibility |  
| **Logout Button** | Action | Clears JWT, redirects to `/auth` |  
---

## Security Analysis

### Authentication & Authorization

**Mechanisms:**  
```  
1. JWT Token-Based Auth  
   - Issued on login: eyJhbGc...  
   - Expiry: 24 hours  
   - Refresh token: 7 days  
   - Stored in httpOnly cookie (secure, sameSite=strict)

2. Password Security  
   - Minimum 8 chars, 1 uppercase, 1 number, 1 special char  
   - Hashed with bcrypt (salt rounds: 12)  
   - Never stored in plain text

3. Rate Limiting  
   - Login: 5 attempts per 5 minutes per IP  
   - API: 100 requests per minute per user  
   - File uploads: 10MB max, 20 per day

4. CORS  
   - Allowed origins only  
   - Methods: GET, POST, PATCH, DELETE  
   - Credentials: Include (for cookies)  
```

### Sensitive Data Handling

| Data | Protection |  
|------|-----------|  
| **Passwords** | Bcrypt hashed (never logged, never sent) |  
| **Tokens** | httpOnly cookies, short expiry (24h) |  
| **Receipt Images** | Encrypted in Supabase Storage, access controlled |  
| **Email Addresses** | Hashed in audit logs (not plain text) |  
| **Friend Lists** | Private by default (opt-in public) |

---

## Future Upgrades & Scalability

### Phase 2: Advanced Features (Weeks 9-16)

#### 1. Bank Integration  
```  
API: Plaid/Open Banking  
- Auto-import transactions from bank accounts  
- Smart categorization (ML-free: rule-based)  
- Reconciliation UI

Backend:  
- New table: bank_accounts  
- Webhook handler for transaction updates  
- Duplicate detection (amount + date within 2 hours)

```

#### 2. Recurring Expenses  
```  
Features:  
- Define recurring expense (weekly/monthly)  
- Auto-log on schedule  
- Manage recurring rules

New Tables:  
- recurring_expenses (id, user_id, amount, category, frequency, next_date)

Backend:  
- Celery beat job: Daily check for due recurrences  
- Create expense entries automatically

```

#### 3. Budget Goals  
```  
Features:  
- Set monthly budgets per category  
- Visual progress bar  
- Alert when 80% of budget spent  
- Month-end summary

New Tables:  
- budgets (user_id, category_id, target_amount, month)

API:  
- POST /api/budgets  
- GET /api/budgets?month=2025-01

Notifications:  
- Push alert when exceeding budget  
- Email digest on month-end

```

#### 4. Achievements & Badges  
```  
Achievements:  
- "First Step": Log first expense (+10 points bonus)  
- "Saving Hero": Save 10 wishes in a month  
- "Top Spender": Rank #1 on leaderboard  
- "Streak": Log expense every day for 7 days

Implementation:  
- Define badge rules in config  
- Background job: Daily badge check  
- Animate badge unlock on frontend

```

#### 5. Advanced Analytics  
```  
Features:  
- Spending trends (month-over-month charts)  
- Forecasting (regression model)  
- Category insights ("You spent 20% more on coffee this month")  
- Peer comparison ("Your friends spend 15% more on groceries")

Tech:  
- Python scipy/sklearn for trends  
- Time-series data in PostgreSQL  
- Precompute trends nightly

```

#### 6. Mobile App  
```  
Tech: React Native (code sharing with web)  
Features:  
- Native camera for receipt capture  
- Offline mode with sync  
- Push notifications  
- Home screen widget (points balance)

```