# Flip the Joy - Ruby on Rails Travel App

**Flip the Joy** is a light, Ruby-based travel app designed to spark joy in every journey. Explore routes, discover hidden gems, and plan adventures that make you smile. 

### For Travelers
- Browse available trips
- Search trips by destination
- Book trips and manage existing bookings
- Checkout and manage payments
- View booking status (Paid, Pending, Failed)

### For Travel Agents
- Create, edit, and delete trips
- Manage trip details: destination, schedule, pricing, min/max travelers
- Upload images to Cloudinary
- Set trips as recurring
- View booking deadlines and trip statuses

### Shared Features
- Authentication using Devise (Sign Up / Sign In / Forgot Password)
- Role-based access control: Travel Agent vs Traveler
- Fully responsive design
- Accessible and intuitive UI

## Technology Stack

- **Backend:** Ruby on Rails 7
- **Database:** SQLite (development), PostgreSQL (production)
- **Authentication:** Devise
- **Image Hosting:** Cloudinary
- **Frontend:** HTML, CSS (responsive)
- **Testing:** RSpec / Capybara (optional)

## Models & Associations

- **User**
    - Represents both travelers and travel agents.
    - Each user has a role (traveler or travel agent).
    - Travelers can book trips.
    - Travel agents can create trips and view bookings for their trips.

- **Role**
    - Defines the type of user: traveler or travel agent.
    - Users are associated with a role.

- **Trip**
    - Represents a travel trip created by a travel agent.
    - Attributes include destination, schedule, meeting point, maximum/minimum participants, price, and status (open, closed, past).
    - A trip has many bookings and many travelers through bookings.

- **BookedTrip**
    - Represents a booking by a traveler for a specific trip.
    - Tracks booking status: pending payment, paid, or cancelled.
    - Linked to payments made for the trip.

- **Payment**
    - Represents a payment for a booked trip.
    - Tracks status: pending, completed, or failed.
    - Associated with a booked trip and records amount and payment method.

## Validations & Rules

- **User**
    - Must have a unique email and a role assigned.

- **Trip**
    - Requires destination, meeting point, minimum and maximum participants, and price.
    - Maximum participants must be greater than or equal to minimum participants.

- **BookedTrip**
    - Unique per traveler per trip to prevent double bookings.

- **Payment**
    - Must have an amount greater than zero and a valid payment method.

## Setup Instructions

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/flip-to-joy.git
   cd flip-to-joy
   ```

2. Install dependencies:
   ```bash
   bundle install
   yarn install
   ```

3. Setup database:
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. Run the Rails server:
   ```bash
   rails server
   ```

5. Open the app in your browser:
   ```bash
   http://localhost:3000
   ```

## Running Tests
   ```bash
   bundle exec rspec
   ```

## Notes

- Active Storage and local uploads are not required if you only use Cloudinary.
- Seeds include sample trips and users for testing.  Installing Active Storage is recommended.
- Roles:

    - `Travel Agent` – can manage trips.
    - `Traveler` – can browse and book trips.

SO, **Flip to Joy** with every trip and find your adventure!
 
## License

This project is licensed under the MIT License.


