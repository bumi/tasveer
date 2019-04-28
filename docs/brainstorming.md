# Project Tasveer

Automated photo printing processes

## Assumptions:

* Subscription of physical photo products work
* Combining elements of private digital and analog photography is fun
* Collaborative collecting of photos works as incentive

## Basic idea:

Collection of photos of one person or a group of people get automatically printed and delivered once a certain amount of photos is collected.

Pictures get selected from the user's photo collection on the phone based on predefined criterias. (e.g. favorits, album, timeframe)

### Genreal thoughts

We set the selection of the photo that should be printed to the moment when the photos are 
taken and move it away from the moment when photos are chosen for print.

The thought about printing the pictures is completely removed and the physical print becomes
a by-product of the process of taking photos.

Collections are created collaboratively

Minimal user interaction is required but standard automated processes apply (e.g. every favored photo in a time frime)

Maybe automated smart selection of photos can be applied (similar to what the Camara app is doing with automated collections)


## First steps

* Prototype of client and server application
* Selection of physical product and partners
* Landing page for marketing validations

### App prototype

We want to test the selection and upload process with a group of beta testers.

The main experiment will be around the user interaction for the selection and upload process.


### Screens

#### Collection list / index
* An overview of the created collections containing basic information (number of photos, participants)
* Option to create a new collection
* upload status: number of photos that are not synced yet

#### Collection new
Creation a new Collection by selecting criteria options:
  - favorits
  - timeframe
  - album
  (minimum one is required; a combination can be used to further filter the selection (e.g. favorits of a certain album)

#### Collection show
* Show collection details (selection criteria)
* Invite collaborators
* List of photos
* Manually add a photo (from the gallery)

#### Collaborator new
Invite a new collaborator to a specific collection by providing an email address
Discuss: signup/login flow: maybe deep link with invitation hash?

#### Invitation accept
Basically the same as collection new but to join an existing collection
Selecting criteria options (like collection new) 


#### (no screen) Application should be registerd as photo activity
Photos can be shared with the application which will give the user the option to add the photo 
to an existing collection.


### Basic flow within the application

* user creates a new collection
* user optionally invites collaborators
* photos matching the criteria are uploaded automatically in the background


### Server API endpoints

#### Device/user registration POST /signup
Registration should happen automatically when the app is started.
An access token will be retured to authenticate future API calls

#### Collections

##### creation POST /collections
Register a new collection with sepcific attributes

##### index GET /collections
List collections for specific devise

##### show GET /collections/:id
Show details of a specific collection including photos

#### invite POST /collections/:id/invite
Invite a new user/devise to collaborate

#### Photos

##### upload POST /collections/:id/photos
Upload a new photo to a collection


## Questions:

* How can we do as much as possible in the background?
  - photo uploading automatically once the application is opened?
  - push notifications with reminders
* Whate are the background processing rules on iOS? (Sync without opening the app?)

## ToDo:

* basic wireframes and user stories
