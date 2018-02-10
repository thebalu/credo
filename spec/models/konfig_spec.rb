require 'rails_helper'

RSpec.describe Konfig, type: :model do

  context "Updating counts" do

    it "works with standard konfig (1 10, start 1)" do
      konf = FactoryBot.create :konfig
      konf.reload
      (1..25).each do |n|
        konf.deck.cards.create(front: "Card #{n} front", back: "back")
      end

      konf.reset_day
      grade = 1
      go = true
      while card = konf.get_card # there are new cards available
        old_count = konf.counts
        q = card.queue
        step = card.learning_step

        card.answer_card(grade % 3 + 1)
        konf.reload
        # puts "#{old_count} --#{grade % 3 + 1}--> #{konf.counts}"
        # puts konf.reps

        if(q=="unseen")
          expect(konf.unseen_count).to eq old_count[:unseen]-1
          case grade%3+1
            when 1
              expect(konf.learn_count).to eq old_count[:learn]+2
            when 2
              expect(konf.learn_count).to eq old_count[:learn]+1
            when 3
              expect(konf.learn_count).to eq old_count[:learn]
          end
        end

        if(q=="learn" && step==0)
          expect(konf.unseen_count).to eq old_count[:unseen]
          case grade%3+1
            when 1
              expect(konf.learn_count).to eq old_count[:learn]
            when 2
              expect(konf.learn_count).to eq old_count[:learn]-1
            when 3
              expect(konf.learn_count).to eq old_count[:learn]-2
          end
        end

        if(q=="learn" && step==1)
          expect(konf.unseen_count).to eq old_count[:unseen]
          case grade%3+1
            when 1
              expect(konf.learn_count).to eq old_count[:learn]+1
            when 2
              expect(konf.learn_count).to eq old_count[:learn]-1
            when 3
              expect(konf.learn_count).to eq old_count[:learn]-1
          end
        end

        grade += 1
      end
    end

    it "works with a different konfig (1 3 5 7, start 2)" do
      konf = FactoryBot.create :konfig, grad_steps:'1 3 5 7', starting_step:2, new_limit:50
      konf.reload

      (1..56).each do |n|
        konf.deck.cards.create(front: "Card #{n} front", back: "back")
      end

      konf.reset_day
      grade = 1
      go = true
      while card = konf.get_card # there are new cards available
        old_count = konf.counts
        q = card.queue
        step = card.learning_step


        card.answer_card(grade % 3 + 1)
        konf.reload
        puts "#{old_count} --#{grade % 3 + 1}--> #{konf.counts}"
        puts konf.reps

        if(q=="unseen")
          expect(konf.unseen_count).to eq old_count[:unseen]-1
          case grade%3+1
            when 1
              expect(konf.learn_count).to eq old_count[:learn]+4
            when 2
              expect(konf.learn_count).to eq old_count[:learn]+2
            when 3
              expect(konf.learn_count).to eq old_count[:learn]
          end
        end

        if(q=="learn" && step==0)
          expect(konf.unseen_count).to eq old_count[:unseen]
          case grade%3+1
            when 1
              expect(konf.learn_count).to eq old_count[:learn]
            when 2
              expect(konf.learn_count).to eq old_count[:learn]-1
            when 3
              expect(konf.learn_count).to eq old_count[:learn]-4
          end
        end

        if(q=="learn" && step==1)
          expect(konf.unseen_count).to eq old_count[:unseen]
          case grade%3+1
            when 1
              expect(konf.learn_count).to eq old_count[:learn]+1
            when 2
              expect(konf.learn_count).to eq old_count[:learn]-1
            when 3
              expect(konf.learn_count).to eq old_count[:learn]-3
          end
        end
        if(q=="learn" && step==2)
          expect(konf.unseen_count).to eq old_count[:unseen]
          case grade%3+1
            when 1
              expect(konf.learn_count).to eq old_count[:learn]+2
            when 2
              expect(konf.learn_count).to eq old_count[:learn]-1
            when 3
              expect(konf.learn_count).to eq old_count[:learn]-2
          end
        end

        if(q=="learn" && step==3)
          expect(konf.unseen_count).to eq old_count[:unseen]
          case grade%3+1
            when 1
              expect(konf.learn_count).to eq old_count[:learn]+3
            when 2
              expect(konf.learn_count).to eq old_count[:learn]-1
            when 3
              expect(konf.learn_count).to eq old_count[:learn]-1
          end
        end
        grade += 1
      end
    end

  end
end
