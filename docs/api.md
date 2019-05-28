## Tasveer API

API host: https://kuvakehys-tasveer.herokuapp.com

## Authentication
The user identifier must be passed as `X-API-KEY` HTTP header.

    X-API-KEY => "usr-xxxx"

## Users

### Object
```
{
  "identifier": "usr-xxxx",
  "email": null,
  "name": null,
  "device_id": "xxxxx"
}
```

### POST /users
Registers a new user

### Request
* user[device_id]
* user[email] (optional)
* user[name] (optional)

### GET /users/me
Returns the user details of the authenticated user

### GET /users/[device_id]
Returns the details of a user by device_id


## Collections

### Object
```
{
  "name": "XXX",
  "description": "",
  "identifier": "cln-xxx",
  "created_at": "2019-05-11T14:41:30.408Z",
  "photo_ids": [
    "pht-xxx"
  ],
  "user_ids": [
    "usr-xxx"
  ],
  users: [],
  photos: []
}
```

### POST /collections
Creates a new collection

#### Request

* collection[name] (optional)
* collection[description] (optional)
* collection[filter] JSON object with the user's filter details

### GET /collections/[id]
Returns the collection details

### GET /collections
Returns the collections of the authenticated user

### PUT /collections/[id]
Updates a collection. Uses the same parameters as for creating a new collection

### POST /collections/[id]/invitations
Creates a new invitation for an email address

#### Request
* invitation[email]
* invitation[message] (optional)

## GET /collections/[collection_id]/photos
Returns an array of all photos of a collection

## Memberships

### GET /memberships
Returns the membership details of the authenticated user.  
This includes the collection details and the user specific filter details.

### Object
```
  {
    collection_id: 'cln-xxx',
    collection: { collection details (see Collection) but only with IDs of photos and users },
    user_id: 'usr-xxx',
    filter: {}
    created_at: "2019-05-11T14:41:30.408Z"
  }
```

## Invitations

### Object
```
  {
    "identifier": "inv-xxx",
    "email": "recipient@example.com",
    "collection_id": "cln-xxx",
    "sender_id": "usr-xxx",
    "accepted_at": "2019-05-11T14:41:30.408Z",
    "user_id": "usr-xxx-invited-xxx"
  }
```

### PUT /invitations/[id]/accept
Accepts the invitation by the current authenticated user and a new membership for the current user is created to join the collection.


## Photos

### Object
```
{
  "identifier": "pht-xxxx",
  "caption": "xxx",
  "width": nil,
  "height": nil,
  "tag_names": [],
  "file_url": "",
  "file_preview": "",
  "user_id": "usr-xxx",
  "collection_ids": [
    "cln-50827338-b52b-40be-9498-fcb1ca4"
  ]
}
```

### POST /photos
Upload a new photo

#### Request
* photo[file]
* photo[add_to][] Array of collection IDs
* photo[caption] (optional)


### POST /collections/[collection_id]/photos
Upload a new photo for a collection

### PUT /photos/[id]
Updates a photo. Accepts the same parameters as for creating a photo

### DELETE /photos/[id]
Deletes a photo

### POST /photos/[id]/collectionships
Add a photo to one or more collections

### Request
* collectionship[collection_ids][] Array of collection IDs

