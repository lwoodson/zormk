# Zormk #
Zormk provides a Zork-like interface into your ORM model.  With it, you can
navigate the twisting labyrinth of ruby ORM code! 

## Um, Okay.  Elaborate. ##
In Zork, you find your location rendered as text, and you interact with the 
environment through commands typed into a command line.  Part of the rendering 
of your location are the exits to other locations.  You move about the 
environment by moving from location to location, with your screen being updated 
with text describing each location as you move.

In Zormk, your model classes (and soon instances) are bound to the locations.
When you arrive at a location, you see a text rendering of the Model class,
including its superclass, mixins, column attributes, and associations using a
ERD-ish like key format.  The paths between locations are the relationships
between your models.  Has one, has many, many to many, etc...  You move from
location to location by travelling down these paths.  At each stop, you see a
new ERD-ish rendering of your model.

## Good God, Why?! ##
I was suffering through a mental dry spell, started a new new job with a complex
rails app and had this resulting frenzy of mental masturbation.  The application
was large, 400+ models, model classes with 12+ mixins, each with their own 
associations, etc...  Making heads or tails of it was difficult for anyone that
did not write it incrementally.  So I wrote Zormk, and it actually has proved 
useful in coming to understand what I was working with.

## A Picture Is Worth 1000 Words ##
Here is a demo session of zormk with the dummy application in the spec
directory.  Its domain model is of a blog site as follows:

* Author has many posts.  It has many comments through posts.
* Posts belong to Author, they have many comments.  They have and belong to 
many tags.
* Comments belong to posts.
* Tags have and belong to many posts.

Given the above model, here is an example Zormk session executed from the rails
console.

```
1.9.3-p125 :001 > Author.zormk
Welcome!  The minions of your project grow stronger...
────────────────────────────────────────
Author [AUTHORS]
  ◃──  ActiveRecord::Base
  ◃--  Author::GeneratedFeatureMethods
────────────────────────────────────────
    -  created_at: datetime
    -  first_name: string
    -  id: integer
    -  last_nanme: string
    -  updated_at: datetime
  ○─∈  comments: [Comment] through posts
  ○─∈  posts: [Post]
────────────────────────────────────────

Paths: comments, posts

> help
Available commands: exit, go, help, key, legend, look, ls, move, quit

> look /comment/i
  ○─∈  comments: [Comment] through posts
Paths: comments, posts

> go posts
Moving to Post...

────────────────────────────────────
Post [POSTS]
  ◃──  ActiveRecord::Base
  ◃--  Post::GeneratedFeatureMethods
────────────────────────────────────
    -  author_id: integer
    -  body: string
    -  created_at: datetime
    -  id: integer
    -  title: string
    -  updated_at: datetime
  ∋─○  author: Author
  ○─∈  comments: [Comment]
  ∋─∈  tags: [Tag]
────────────────────────────────────

Paths: author, comments, tags

> go tags
Moving to Tag...

───────────────────────────────────
Tag [TAGS]
  ◃──  ActiveRecord::Base
  ◃--  Tag::GeneratedFeatureMethods
───────────────────────────────────
    -  created_at: datetime
    -  id: integer
    -  tag_name: string
    -  updated_at: datetime
  ∋─∈  posts: [Post]
───────────────────────────────────

Paths: posts

> go posts
Moving to Post...

────────────────────────────────────
Post [POSTS]
  ◃──  ActiveRecord::Base
  ◃--  Post::GeneratedFeatureMethods
────────────────────────────────────
    -  author_id: integer
    -  body: string
    -  created_at: datetime
    -  id: integer
    -  title: string
    -  updated_at: datetime
  ∋─○  author: Author
  ○─∈  comments: [Comment]
  ∋─∈  tags: [Tag]
────────────────────────────────────

Paths: author, comments, tags

> go comments
Moving to Comment...

───────────────────────────────────────
Comment [COMMENTS]
  ◃──  ActiveRecord::Base
  ◃--  Comment::GeneratedFeatureMethods
───────────────────────────────────────
    -  body: string
    -  commentator: string
    -  created_at: datetime
    -  id: integer
    -  post_id: integer
    -  updated_at: datetime
  ∋─○  post: Post
───────────────────────────────────────

Paths: post

> go post
Moving to Post...

────────────────────────────────────
Post [POSTS]
  ◃──  ActiveRecord::Base
  ◃--  Post::GeneratedFeatureMethods
────────────────────────────────────
    -  author_id: integer
    -  body: string
    -  created_at: datetime
    -  id: integer
    -  title: string
    -  updated_at: datetime
  ∋─○  author: Author
  ○─∈  comments: [Comment]
  ∋─∈  tags: [Tag]
────────────────────────────────────

Paths: author, comments, tags

> go author
Moving to Author...

────────────────────────────────────────
Author [AUTHORS]
  ◃──  ActiveRecord::Base
  ◃--  Author::GeneratedFeatureMethods
────────────────────────────────────────
    -  created_at: datetime
    -  first_name: string
    -  id: integer
    -  last_nanme: string
    -  updated_at: datetime
  ○─∈  comments: [Comment] through posts
  ○─∈  posts: [Post]
────────────────────────────────────────

Paths: comments, posts

> go comments
Moving to Comment...

───────────────────────────────────────
Comment [COMMENTS]
  ◃──  ActiveRecord::Base
  ◃--  Comment::GeneratedFeatureMethods
───────────────────────────────────────
    -  body: string
    -  commentator: string
    -  created_at: datetime
    -  id: integer
    -  post_id: integer
    -  updated_at: datetime
  ∋─○  post: Post
───────────────────────────────────────

Paths: post

> exit
Goodbye!  The minions of your project grow weaker...
```

## WTF Is All That Unicode?! ##
Zormk uses keys to represent relationships in the model.  These sort of
correspond to a bastardized ERD and UML pidgin that makes sense from a command
line terminal.  You can use the legend or key command in zormk to see
explanations as follows:

```

◃── Superclass
◃-- Mixin
  - Table column
──○ One-to-one (unidirectional to other)
○── One-to-one (unidirectional to this)
○─○ One to one (bidirectional)
──∈ One to many (unidirectional)
○─∈ One to many (bidirectional)
∋── Many to one (unidirectional)
∋─○ Many to one (bidirectional)
∋─∈ Many to many (bidirectional)
```

For the associations, the left hand side applies to your current model class
and the right hand side applies to the other model class.

## Can We Go For A Test Drive? ##
If you include the gem, you will have a `zormk` method on your model classes
that can be invoked from `irb` or `rails console` to enter the zormk interface.
After that, type help to see available commands and explore.

## What About DataMapper or ... ##
No support is available for ORMs/persistence frameworks other than ActiveRecord 
for now.  I've written the gem to be extensible, however, so there is no reason 
why it couldn't be expanded to include other ORMs if someone wanted to pitch in 
to help support them (or if my own needs came to include them).

## Limitations ##
Right now, this only works with classes.  I want to support traversing a model
instance graph in the future as well.  Often the complexity of a model may not 
be in the relationships between entities and how they are mapped to ruby source
files.  Rather, the complexity may be in how instances are arranged within a
graph.  If you could take an instance of a model and enter zormk on it and then
traverse the paths to associated objects to see their primitive values and
paths to other complex objects, you might be able to do some more interesting
data spelunking.

I don't have the ability to move upwards into superclasses yet.  This is
something I plan to do soon.

## Your Code Has Bugs! ##
Probably cooties, too.  Submit an issue and I'll see about fixing it.

## This Would Be Awesome If... ##
I wish I had thought of that.  Submit a feature request as an issue and I'll
see about adding it.

## Can I Help Fix Bugs or Add Features?! ##
Sure!  Fork it, branch it, commit it, code it, test it, push it then send a pull
request.

## The Fine Print ##
This is free software and may be redistributed under the terms in the
LICENSE.txt file.  Zormk is copyright &#169; 2012 by Lance Woodson.

