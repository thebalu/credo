# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Klass.destroy_all
Student.destroy_all
Deck.destroy_all
Card.destroy_all
Konfig.destroy_all
Schedule.destroy_all

c = Klass.create(name:"Tizedik bé", description:"Best in its class.")
c.students.create(name: "Aladar")
c.students.create(name: "Bela")

d= c.decks.create( name: "TopDeck", description:"Unfair.")

d.cards.create([
    {front: "1", back: "uno"},
    {front: "2", back: "dos"},
    {front: "3", back: "tres"},
    {front: "4", back: "cuatro"},
    {front: "5", back: "cinco"},
    {front: "6", back: "seis"},
    {front: "7", back: "siete"},
    {front: "8", back: "ocho"},
    {front: "9", back: "nueve"},
    {front: "10", back: "diez"},
               ])


d2=c.decks.create( name: "BottomDeck", description:"Not so great.")

d2.cards.create([
                   {front: "cat", back: "gato"},
                   {front: "dog", back: "perro"},
                   {front: "man", back: "hombre"},
                   {front: "woman", back: "mujer"},
                   {front: "blue", back: "azul"},
               ])

c2 = Klass.create(name:"12/a", description:"Good group")
c2.students.create(name: "Cili")
c2.students.create(name: "David")
d3=c2.decks.create( name: "QQdeck", description:"qqq.")

d3.cards.create([
                    {front: "cat", back: "gato"},
                    {front: "dog", back: "perro"},
                    {front: "man", back: "hombre"},
                    {front: "woman", back: "mujer"},
                    {front: "blue", back: "azul"},
                ])