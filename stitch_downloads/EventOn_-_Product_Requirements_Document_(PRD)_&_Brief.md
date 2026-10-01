# Product Requirements Document (PRD): EventOn Mobile Platform

## 1. Executive Summary & Vision
**EventOn** (`eventongo.in`) is an end-to-end event commerce, vendor discovery, and quote-bundling marketplace designed primarily for weddings, engagements, birthday parties, and social celebrations. 

The platform simplifies event planning by bridging event hosts with vetted local vendors across diverse event categories (venues, catering, photography, bridal styling, decor, sound/stage, traditional performers, and rentals). It features localized franchise-territory routing (specifically tailored for Kerala panchayats/municipalities and expanding regional hubs) and allows multi-vendor quote consolidation in a single request.

---

## 2. Target Audience & Personas

### 2.1 Event Hosts / Consumers
- **Demographics:** Couples planning weddings/engagements, families organizing milestone celebrations, corporate/college event planners.
- **Pain Points:** 
  - Fragmented vendor coordination across dozens of standalone service providers.
  - Opaque pricing, hidden charges, and slow quote turnarounds.
  - Difficulty verifying credibility, portfolio authenticity, and service availability.
- **Goals:** Discover verified local talent, compare upfront pricing, curate vendor shortlists, and request bundled quotes in one tap.

### 2.2 Event Vendors & Service Providers
- **Categories:** Venues & banquets, caterers, photographers & cinematographers, makeup artists & stylists, stage decorators, pandal/furniture suppliers, DJs/sound engineers, mehendi artists, traditional art performers, vintage car & luxury vehicle rentals.
- **Pain Points:** High customer acquisition costs, geographic mismatch of leads, lack of unified booking tools.
- **Goals:** Acquire qualified local leads, showcase verified credentials and past portfolios, manage quote requests seamlessly.

### 2.3 Franchise Partners & Regional Hub Operators
- **Role:** Local business development and verification partners tied to designated regional franchise territories (Panchayat / Municipality / Corporation level).
- **Incentives:** Commission allocation based on consumer pin code and local governance territory.

---

## 3. Core Product Pillars & Value Propositions
1. **Verified Network:** 100% physically vetted vendors with review and quality screening.
2. **Transparent Discovery:** Upfront pricing structures (e.g., *From ₹6,500*, *₹650/plate*, *₹45,000/day*), guest capacity meters, and real review badges.
3. **Multi-Vendor "Bucket" Quoting:** Select multiple vendors across services and execute a unified quote inquiry via the sticky quotation bar.
4. **Hyper-Local Routing:** Territory-based franchise routing ensuring hyper-local support and verified vendor proximity.
5. **Event Concierge:** High-touch assistance for large-scale wedding bundling and tailored package creation.

---

## 4. Key User Journeys & Screen Specifications

### 4.1 Onboarding & Authentication
* **Mobile OTP Sign-In (`Sign In Mobile`):** Phone number entry (+91 prefill), OTP verification, Google SSO alternative.
* **Email Authentication (`Sign In Email` / `Sign Up Email`):** Full name, email, password with toggle reveal, password recovery assistance, and vendor onboarding links (*"List your business"*).

### 4.2 Home & Occasion-Led Discovery (`Mobile Home`)
* **Location Header:** Dynamic location detector (*"Set your location / See businesses near you"*), user profile avatar / quick status.
* **Occasion Carousel:** High-impact cards for Weddings (16 services), Engagements (14 services), Birthdays (11 services).
* **Category Grid:** 4-column quick links with custom iconography for core categories.
* **Popular Near You:** Filterable vendor showcase (*All, Top Rated, Under ₹25k, New*).
* **Partner Recruitment:** Onboarding banner (*"Run an event business? List it on EventOn — it's free to join"*).

### 4.3 Search, Filter & Listings (`Search & Browse` / `Search Vendors Listing`)
* **Search Field:** Multi-keyword query input with clear trigger and category auto-suggestions.
* **Location & Radius Filter:** Dynamic distance slider/dropdown (*e.g., Alappuzha · 50 km*).
* **Filter Bottom Sheet / Drawer (`Search Filters Drawer`):**
  - Category multi-select pills (Bridal wear, Catering, DJ, Decor, etc.).
  - Budget range inputs (`Min` – `Max` in ₹).
  - Minimum rating filter (`Any`, `★ 3+`, `★ 4+`, `★ 4.5+`).
  - Sort ordering (`Recommended`, `Distance`, `Price: Low to High`, `Rating`).
* **Multi-Quote Sticky Footer:** Sticky drawer tracking selected businesses (*"1 business picked · Request quotes →"*).

### 4.4 Occasion Deep Dive (`Occasion Wedding Services` & `All Services Categories`)
* **Curated Category Index:** Full directory of 16 core service types with descriptive subtitle annotations.
* **Hero Occasion Header:** Full-width visual banner with service count summary.

### 4.5 User Profile & Territory Configuration (`User Profile`)
* **Account Info:** User name, registered email, booking history entry point.
* **Franchise Routing Settings:** Pincode input and Kerala Panchayat / Municipality / Corporation autocomplete to route commissions and localize vendor feeds.
* **Account Management:** Booking dashboard access and session logout.

---

## 5. Design System Specifications

### 5.1 Themes Supported
* **Primary Light Theme (Luminous Teal Clarity):**
  - Surface: `#ffffff` / `#faf8ff` / `#f2f3ff`
  - Primary Accent: Deep Teal (`#0f766e` / `#0d9488`)
  - Accent Mint / Highlights: `#2dd4bf`
  - Text: Dark slate `#0f172a`, Muted `#64748b`
* **Alternate Dark Theme (Nocturne Celebration):**
  - Background & Surface: `#041614` / `#0c1f1d`
  - Accent Mint: `#4fd1c5` / `#5eead4`
  - Contrast Containers: Crisp pure white cards for service grids and high-visibility listing tiles.

### 5.2 Typography & Shape Standards
* **Font Family:** `DM Sans` (Google Fonts) with geometric, friendly numbers and clean heading weights.
* **Corner Radius:** 
  - Standard Cards: `16px` (`rounded-2xl`)
  - Icon Badges & Squircles: `20px` – `24px`
  - Pill Buttons & Search: Full pill (`rounded-full`)

---

## 6. Technical & System Architecture Recommendations

### 6.1 Frontend Stack
* **Framework:** React / Next.js or Mobile Progressive Web App (PWA) / React Native.
* **Styling:** Tailwind CSS with custom theme token mappings.
* **Component Paradigm:** Atomic, mobile-first design targeting 390px portrait viewport with responsive desktop adaptations.

### 6.2 Backend & Data Model Entities
* **Users:** ID, name, email, phone, role (`customer`, `vendor`, `franchise_admin`), location metadata (`pincode`, `local_body_id`).
* **Vendors:** Business name, category ID, pricing model (`per_day`, `per_plate`, `fixed`), verified status, location coordinates, rating, review count, media gallery.
* **Quotes & Inquiries:** Inquiry ID, customer ID, array of vendor IDs, occasion date, guest count, estimated budget, status (`pending`, `quoted`, `booked`).
* **Local Governance Bodies:** Kerala Panchayats/Municipalities/Corporations database for territory-based lead and commission attribution.

---

## 7. Metrics & KPIs for Success
* **Vendor Discovery to Quote Conversion Rate:** Percentage of users visiting a listing who tap "+ Quote" and complete the inquiry request.
* **Multi-Vendor Basket Size:** Average number of distinct vendors bundled into a single quote request (target: ≥ 2.4 vendors per inquiry).
* **Local Density Liquidity:** Ratio of inquiries successfully matching with vendors within a 30 km radius.
* **Time to First Quote:** Average response turnaround time from vendors to consumer quote inquiries.
