# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

c = Klass.create(name:"Tizedik bé", description:"Best in its class.")
c.students.create([
                    {name: "Aladar"},
                    {name: "Bela"},
                    {name: "Cili"},
                    {name: "Dodus"},
                    {name: "Emese"},
                  ])

d= c.decks.create( name: "TopDeck", description:"Unfair.")

d.cards.create([
    {front: "1", back: "uno"},
    {front: "2", back: "dos"},
    {front: "3", back: "tres"},
    {front: "4", back: "cuatro"},
    {front: "5", back: "cinco"},
               ])