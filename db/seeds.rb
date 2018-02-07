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

c = Klass.create(name:"Tizedik bé", description:"Best in its class.")
aladar=c.students.create(name: "Aladar")
bela=c.students.create(name: "Bela")

d= c.decks.create( name: "TopDeck", description:"Unfair.")

d.cards.create([
    {front: "1", back: "uno"},
    {front: "2", back: "dos"},
    {front: "3", back: "tres"},
    {front: "4", back: "cuatro"},
    {front: "5", back: "cinco"},
               ])

Student.all.each {|s| s.konfigs.create(deck:d, grad_steps:"1 10", starting_step:1)}