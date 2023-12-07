# README

Thank you for reading my application! I had about 5 hours today to
work on it. I got a lot of things done, and there's a lot of room for
improvement. I tend to write documentation very quickly, so I attempted
to capture my thought process here. Please forgive me for the novel.

# running the application
The application involves a database. Make sure to create and migrate 
the database before you run the code with `rake db:create` and `rake 
db:migrate`

The application requires an API key for the google cloud vision service.
This key is hidden via the gitignore and you will need to create one.
To do so, rename the file  `config/app_environment_variables example.rb`
to `config/app_environment_variables.rb` and change the value to a
valid API key. (Note: I'm happy to send one along; just trying to
follow best practices here).

Run the app with `rails s`

# the API
The API runs off of the endpoint /analyze_images. There is no UI,
but if you run the app locally and navigate to /image_data, you will
see a JSON response blob of all of the image data (like an index 
page). This was primarily because I found it helpful in development;
users should primarily interact via the /analyze_images endpoint.

The /analyze_images endpoint requires an `image` in the request
body. The value of the image should be a file. It can take a `name` 
(for easier reference) and a `description,` though those are not 
required.

# tests

## automated testing
This application uses rspec. Run tests with `bundle exec rspec spec`

## manual testing
The application "Postman" was very helpful in testing the API as I
built it. If you choose to test with Postman, it allows you to 
send an image if you go into the "body" tab and then select the
data type dropdown in the "key" field. The dropdown defaults to 
"Text".

# application structure
There is no UI for this application. Users are expected to work
by querying the /analyze_image endpoint.

When the /analyze_image endpoint is hit, in the `ImageDataController`,
the app creates a new `ImageDatum` with the parameters provided. The 
`ImageDatum`` model uses the has the `Image` uploader mounted to it to 
handle the image. The uploader is provided by a gem called CarrierWave. 
Then, we attempt to save the data. If it fails (presumably due to an 
error in the data itself, such as an incorrect file type provided), it 
returns an error and does not attempt to generate a description. If the 
save succeeds, then the `Querier` model attempts to use the Google Cloud 
Vision gem to make a call to the Google service and return description data.

# what works, what doesn't, what I'd change

## writing in ruby
I made an early judgement call--to write the application in Ruby, because 
I miss writing in Ruby and I want to do it more often. In retrospect, I 
absolutely should have looked at the documentation for the vision APIs 
before I made this decision. It turns out the Ruby documentation for some 
of these libraries is not very robust. Much of it is from 3+ years ago. 
Many of the examples have been removed from the internet. Much of the 
documentation was accurate to an older version of Ruby, and is not to a 
current version. By the time I figured this out, I had already put too 
much time into the Rails version of the application, and I knew I wouldn't 
have time to rewrite it in python or another language with more robust 
documentation. As a result, I spent an unfortunate amount of my time 
flipping between out-of-date vision API documentation, and Ruby docs on 
how to update code for more recent versions. This left me with a lot less 
time for things like robust error handling and testing.

If I could start over, I would rewrite it in Python.

## automated tests
I began writing this project in TDD but then had to move away from that
practice as the time constraint implemented by my poor technology choice
became apparent; I optimized for slightly more functional code and left
(commented out) the tests I had initially written, even though they didn't 
all work as expected or accurately reflect the end state of the code, to
show some of my thought process.

Even writing the tests was a challenge; the CarrierWave gem handles
`image.nil?` in an atypical way and it uses `image.exists?` to replace
that functionality, but `image.exists?` breaks on the tests, because 
FactoryBot isn't actually creating CarrierWave image records. In order to
test this more robustly, I would need to either mock the `.exists?` call
or to move from the FactoryBot implementation into one more CarrierWave-like.
Here again, I ran into issues with documentation existing in very old versions
of Ruby, referencing methods that don't exist, and increasing the time required
to resolve the issue.

## edge cases
There are several unaccounted for edge cases--most notably, right
now the app assumes that the google vision response will be successful.

The error messaging isn't robust and doesn't provide much information about
why things didn't work. I haven't played around with different file types
to see what happens. There is very little exploration of edge cases here.

# further explanation

## judgement calls and decisions
I made judgement calls at several points in this application. I 
will discuss some of them here. When I develop, I am trying to 
imagine not just the application itself, but potential future uses 
of the application, and optimizations I can add that will improve 
the future experience without compromising the existing features. 
This often is much cheaper and more efficient overall.

### index page
Depending on use case, this could be a security problem. Given this
is an interview, the tradeoffs for quick easy visibility seemed
worth the basically nonexistent risks.

### `Querier` as its own object
I chose to make `Querier` its own model, even though the `ImageDatum` 
model is arguably small enough it could have cleanly held that logic. 
This was for two reasons. First, I wasn't sure when I started exactly 
what the implementation would look like; when I believed I would be 
building an API wrapper, putting that logic in its own object made 
the most sense. Secondly, and more importantly, I think that 
particulary when working with 3rd party applications that might 
change in ways that we cannot cleanly expect, it's important to 
separate that logic as much as possible. That way, if the gem stops 
working, or business needs change, or we get a great deal working 
with Bing instead of Google, we can make the necessary adjustments
cleanly in one small section of the code that is isolated from the 
rest of our business logic, instead of needing to chase the logic 
throughout our codebase.

### option to pass in a description
Although it wasn't included in the specifications, I included the 
ability to pass in a description as a part of the API call. If a 
user passes in a description, we don't use the 3rd party API to 
generate a description.

I did this for two reasons. First, I can imagine a use case where 
this functionality is preferred. If I am creating a tool for 
educators to share images of their classrooms with parents, for 
example, I could imagine both an educator who wants to lovingly 
hand-tailor their descriptions, and I could imagine a busy 
educator who doesn't have time, or only has the time to write 
descriptions for certain vital images. I wanted to be able to 
preserve additional text if it is provided in order to serve all 
three of these customer types.

Second, there is a cost to an API hit. In addition to direct costs 
from 3rd parties, which may charge for every API hit, there is also 
the cost of the time it takes to query the API and receive and 
parse a response. We also don't control this element; if the API 
starts taking twice as long to resolve queries, or it shuts down 
completely, we have no recourse. Limiting the API calls when 
possible seems like a wise option.

### saving the data
There was no requirement in the specifications to save the data 
in any way, and to some extent, saving images can be dangerous. 
Frankly, as an individual and not a corporation, I personally 
want to have ownership over 3rd party images as little as 
possible, since I have no control over the sensitivity of the 
data provided. So why on earth did I add it to the database?

Well, a few reasons. First, this is a small sample app for an 
interview, and I'm not hosting it on the internet anywhere; 
chances that a user will upload something sensitive or dangerous 
that I will then have to secure are nonexistent.

Second, I want to reduce my 3rd party API calls as much as 
possible. Data gives me some help in doing this. If I am storing 
my data, then I can take advantage of ActiveRecord and use 
features like find_or_replace to ensure that I actually have a 
new image before I hit the endpoint. It will also mean that we 
don't have to pay for double-clicks; if a user accidentally 
submits the same API query multiple times in a row, we will hit 
the 3rd party on the first unique API hit, but not on the 
subsequent repeats.
