# Eventz Rails App

Eventz is a Events Listing and Registration application.  Guests can see the events that are listed.  Guests can sign up for an account to become a user.  Users can register for events and like events.  Admins can create events and categories for categorization of the event.  This application uses all the different types of models and relationships.  One to Many, Many to Many, and through Association via Join Models.  It uses the bcrypt gem for authentication and basic helper methods for authorization.  It uses scope for order the listings, a method to create user-friendly urls, stores the images using local active storage for development and Amazon Web Services S3 for the images with a Heroku deployment.

## Getting Started

These instructions will allow you to make a copy of the project yourself, and get it up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

RubyMine 2019.3, Ruby 2.6.6, and Rails 6.0.2.2 were used to initially make this project on a machine with SQLite.  I try to keep the application up to date so if the latest commit doesn't work try going back to an earlier one.

## FOR REFERENCE:

### Friendly URL

Generate a new migration that adds a slug column to the events table:

```shell
rails generate migration AddSlugToEvents slug
```

Apply migratation:

```shell
rails db:migrate
```

Add validation to make sure event title is unique so the url can be based on a unique source:

```
validates :title, presence: true, uniqueness: true
```

Define a private method in the Event model:

```shell
def set_slug
    self.slug = title.parameterize
end
```

Use the before_save method to call set_slug prior to every save in the Event Model:

```shell
before_save :set_slug
```

Define a to_param method in the Event Model:

```shell
def to_param
    slug
end
```

Update EventsController, RegistrationsController, and LikesController Actions to find events by their slug:

```shell
def set_event
    @event = Event.find_by!(slug: params[:id])
```

### Scopes and Routes

Create scopes in the Events Model:

```shell
scope :free, -> { upcoming.where(price: 0.0).order(:name) }
scope :past, -> { where("starts_at < ?", Time.now).order("starts_at") }
scope :recent, ->(max=3) { past.limit(max) }
scope :upcoming, -> { where("starts_at > ?", Time.now).order("starts_at") }
```

Create filter route for new scopes in routes.rb:

```shell
get "events/filter/:filter" => "events#index", as: :filtered_events
```

Update Index Action in EventsController to handle :filter params:

```shell
def index
  case params[:filter]
  when "past"
    @events = Event.past
  when "free"
    @events = Event.free
  when "recent"
    @events = Event.recent
  else
    @events = Event.upcoming
  end
end
```

Add Links:

```shell
<li>
  <%= link_to "Upcoming Events", events_path %>
</li>
<li>
  <%= link_to "Past", filtered_events_path(:past) %>
</li>
<li>
  <%= link_to "Free", filtered_events_path(:free) %>
</li>
<li>
  <%= link_to "Recent", filtered_events_path(:recent) %>
</li>
```

## Running the tests

Tests to come at a later date.  Want to write some?

## Deployment

Should easily deploy to Heroku.  Instructions for that at a later date if needed.

## Built With

* [Ruby](https://www.ruby-lang.org/en/) - Language
* [Ruby on Rails](https://rubyonrails.org) - MVC Framework
* [RubyMine](https://www.jetbrains.com/ruby/) - IDE
* [PostgreSQL](https://www.postgresql.org) - Database

## Contributing

If you want to ...

## Authors

* **Jeremy Hastings** - *Initial work* - [Jeremy Hastings](https://github.com/jeremyhastings/)

## License

This project is licensed under the GNU General Public License 3.0 License - see the [LICENSE.md](LICENSE.md) file for details
