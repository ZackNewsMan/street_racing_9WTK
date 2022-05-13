# My boss wanted me to get the rest of 2021 and the beginning of 2016 in this data. So I am re-doing my analysis with this additional info.

library(tidyverse)

problems(...)

# More convictions based on judicial officer? 
  # I see unique identifiers in the column "case_judicial_officer_bar_number."

library(tidyverse)

street_race_all <- street_racing_010116_123121_4

race_charge_pt1 <- street_race_all %>% 
  filter(law_number == "42-4-1105") 

race_charge_pt2 <-  street_race_all %>% 
  filter(law_number == "42-4-1105(1)") 

race_charge_pt3 <-  street_race_all %>% 
  filter(law_number == "42-4-1105(1),(3)") 

race_charge_pt4 <-  street_race_all %>% 
  filter(law_number == "42-4-1105(2)") 

race_charge_pt5 <-  street_race_all %>% 
  filter(law_number == "42-4-1105(2),(3)") 

race_charge_pt6 <-  street_race_all %>% 
  filter(law_number == "42-4-1105(2),(5)(a)") 

race_charge_pt7 <-  street_race_all %>% 
  filter(law_number == "42-4-1105(1),(5)(a)") 

  # Full join test:
    # Inspo: https://dplyr.tidyverse.org/reference/mutate-joins.html

race_charge_pt1 %>% full_join(race_charge_pt2)

# It worked! pt 1 has 13 rows and pt 2 has 3,363 rows. After the full join, the table had 3,376 rows :)  

# So let's move the full join down below. We will merge all of the tables together when it is done. 

      race_charge_pt1_2 <- race_charge_pt1 %>% full_join(race_charge_pt2)
      
      race_charge_pt1_3 <- race_charge_pt3 %>% full_join(race_charge_pt1_2)
      
      race_charge_pt1_4 <- race_charge_pt4 %>% full_join(race_charge_pt1_3)
      
      race_charge_pt1_5 <- race_charge_pt5 %>% full_join(race_charge_pt1_4)
      
      race_charge_pt1_6 <- race_charge_pt6 %>% full_join(race_charge_pt1_5)

      race_charge_pt1_7 <- race_charge_pt7 %>% full_join(race_charge_pt1_6)

      # race_charge_pt1_7 has 7,071 rows, the same as the original "charge" doc
      # Confirmed with SQL too:
      # SELECT *
      # FROM street_race_all
      # WHERE trim(law_number) = '42-4-1105(1)'
        # OR trim(law_number) = '42-4-1105'
        # OR trim(law_number) = '42-4-1105(1),(3)'
        # OR trim(law_number) = '42-4-1105(2)'
        # OR trim(law_number) = '42-4-1105(2),(3)'
        # OR trim(law_number) = '42-4-1105(2),(5)(a)'
        # OR trim(law_number) = '42-4-1105(1),(5)(a)'

# But how many distinct cases are there:     
      race_charge_pt1_7 %>% 
        distinct(case_number, .keep_all = TRUE) 
      
      # We want to export to manually enter all names & DOB by hand:
      
      street_race_charge_uniq_cases_2016_2021 <- race_charge_pt1_7 %>% 
        distinct(case_number, .keep_all = TRUE) 
      
      street_race_charge_uniq_cases_2016_2021 %>% write_csv("street_race_charge_uniq_cases_2016_2021.csv", na = "")
      
      # 2,445 unique cases with a speed race charge
      
     all_unique_charges <- race_charge_pt1_7 %>% 
        distinct(case_number, .keep_all = TRUE)   
      
        # Confirmed with SQL:
          # SELECT distinct trim(case_number), *
          # FROM street_race_all
          # WHERE trim(law_number) = '42-4-1105(1)'
            # OR trim(law_number) = '42-4-1105'
            # OR trim(law_number) = '42-4-1105(1),(3)'
            # OR trim(law_number) = '42-4-1105(2)'
            # OR trim(law_number) = '42-4-1105(2),(3)'
            # OR trim(law_number) = '42-4-1105(2),(5)(a)'
            # OR trim(law_number) = '42-4-1105(1),(5)(a)'
          # GROUP BY case_number

# I read through the "Sentence Penalty Codes" document and there's no code for anything other than a penalty (aka no hidden aquittal code in there).     
           
race_charge_pt1_7 %>% 
        filter(!is.na(sentence_penalty_code)) %>% 
        distinct(case_number, .keep_all = TRUE)      
    
r_race_sentence <- race_charge_pt1_7 %>% 
  filter(!is.na(sentence_penalty_code)) %>% 
  distinct(case_number, .keep_all = TRUE)

    all_unique_sentence <- race_charge_pt1_7 %>% 
      filter(!is.na(sentence_penalty_code)) %>% 
      distinct(case_number, .keep_all = TRUE)
 
    # 376 cases with a conviction  

    (376/2445)*100

    # 15% conviction rate   

    # SQL returns totally different results, 349 rows (see below for how I fixed this, 376 is correct). 
      # Will need to export into CSV and do a SETDIFF or similar to see why there is a difference. 
      # SQL queries that return 349:
         # CREATE TABLE race_charge as
         # SELECT distinct trim(case_number), *
         #   FROM street_race_all
         # WHERE trim(law_number) = '42-4-1105(1)'
         # OR trim(law_number) = '42-4-1105'
         # OR trim(law_number) = '42-4-1105(1),(3)'
         # OR trim(law_number) = '42-4-1105(2)'
         # OR trim(law_number) = '42-4-1105(2),(3)'
         # OR trim(law_number) = '42-4-1105(2),(5)(a)'
         # OR trim(law_number) = '42-4-1105(1),(5)(a)'
         # GROUP BY case_number 

         # SELECT *
          #  FROM race_charge
         # where sentence_penalty_code IS NOT NULL

        #  SELECT *
        #    FROM race_charge
        #  where sentence_penalty_code != ""

       # SELECT *
       #   FROM race_charge
       # where sentence_penalty_code <> " "
  
      library(tidyverse)

      setdiff(r_race_sentence,sql_race_sentence) %>% 
        View()

        # I've done a few spot checks and that didn't work as intended. Still in the data even though it's not supposed to be via setdiff
          # C0132020T 000213
          # C0302017T 006627
        # X that's not in Y
          # x [!(x %in% y)]
        
        r_race_sentence [!(r_race_sentence %in% sql_race_sentence)] %>% 
          View()
      
        # Still giving false results. Query is supposed to return only cases that occur in x and not y. But case number check shows that's not the case. 
        
      setdiff(sql_race_sentence,r_race_sentence) %>% 
        View()
      
        # Same issue. Going to try a LEFT JOIN. I need to know why R is returning more cases than SQL
      
        r_race_sentence %>% left_join(sql_race_sentence)
      
        # Returns all 376 rows this way
        
        sql_race_sentence %>% left_join(r_race_sentence)
      
        sql_race_sentence %>% anti_join(r_race_sentence)
      
        r_race_sentence %>% anti_join(sql_race_sentence)
        
    # Chad Day, a mentor that works at the Wall Street Journal, helped me identify the problem with SQL.
        # I needed to filter out the nulls in the sentence category before you group by the case number.
        
       # He pointed out that the R script is filtering the nulls out first and then grouping (correctly). SQL needs to do the same. 
        # the SQL group by is happening before the filtering out of the nulls.
        # The root of this is that the SQL GROUP BY is only happening on the unique case number and SQL/R doesn't know what to do with the rest of the records that you're selecting with the * so it just brings in a random assortment of them, dropping out some values you want to filter on.  See case number C0012016T 009033 as an example. 
        # For this, you'll want to filter out the nulls in the sentence category before you group by the case number. 
        
      # With this query, I fixed the problem. It is now showing 376 unique cases with a street racing charge and a conviction.  
        # SELECT DISTINCT case_number
        # FROM (
        #  SELECT *
        #    FROM street_race_all
        #  WHERE sentence_penalty_code is NOT NULL
        # ) as x
        # WHERE
        # trim(law_number) = '42-4-1105(1)'
        # OR trim(law_number) = '42-4-1105'
        # OR trim(law_number) = '42-4-1105(1),(3)'
        # OR trim(law_number) = '42-4-1105(2)'
        # OR trim(law_number) = '42-4-1105(2),(3)'
        # OR trim(law_number) = '42-4-1105(2),(5)(a)'
        # OR trim(law_number) = '42-4-1105(1),(5)(a)'

# Cases without a sentence
        
        race_charge_pt1_7 %>% 
          filter(is.na(sentence_penalty_code)) %>% 
          distinct(case_number, .keep_all = TRUE) %>% 
          View()
      
      # It's possible that 2021 cases were not adjudicated until 2022 becasue of the pace of the judicial system and pandemic-related delays. 
        # Examples:
          # 2021T4300 -- On 02/11/22, speed exhibition was dismissed but DWAI was guilty (Adams County)
          # 2021T3419 -- On 01/27/22, guilty to a driver's license infraction (Adams)
          # 2021T2057 -- On 03/22/22, facilitating a speed race was dismissed but pled guilty to speeding (Adams)
        
             
# Group race charges by year
        
        all_unique_charges %>% 
          group_by(case_year) %>% 
          summarize(race_charge_count = n())        
        
        # case_year    race_charge_count
        #      2016               412
        #      2017               398
        #      2018               347
        #      2019               366
        #      2020               465
        #      2021               457
        
        # SQL verification:
          # CREATE TABLE uniq_charge as 
          # SELECT distinct trim(case_number), *
          #  FROM street_race_all
          # WHERE trim(law_number) = '42-4-1105(1)'
          # OR trim(law_number) = '42-4-1105'
          # OR trim(law_number) = '42-4-1105(1),(3)'
          # OR trim(law_number) = '42-4-1105(2)'
          # OR trim(law_number) = '42-4-1105(2),(3)'
          # OR trim(law_number) = '42-4-1105(2),(5)(a)'
          # OR trim(law_number) = '42-4-1105(1),(5)(a)'
          # GROUP BY case_number
        
          # SELECT case_year, count(case_year)
          # FROM uniq_charge
          # group by case_year
        
        year_charge <- all_unique_charges %>% 
          group_by(case_year) %>% 
          summarize(race_charge_count = n()) 
        
# And convictions by year      
           
        all_unique_sentence %>% 
          group_by(case_year) %>% 
          summarize(race_sentence_count = n()) 
        
        #  case_year     race_sentence_count
        #      2016                63
        #      2017                70
        #      2018                45
        #      2019                55
        #      2020                87
        #      2021                56
        
        # Sentence spike in 2020 and then back down to pre-2020 levels in 2021
        
        
        #SQL verification:
        
        # CREATE TABLE uniq_sentence AS
        # SELECT DISTINCT case_number, case_year, county_name, case_judicial_officer_bar_number
        #  FROM street_race_all
        # WHERE trim(law_number) = '42-4-1105(1)'
        # OR trim(law_number) = '42-4-1105'
        # OR trim(law_number) = '42-4-1105(1),(3)'
        # OR trim(law_number) = '42-4-1105(2)'
        # OR trim(law_number) = '42-4-1105(2),(3)'
        # OR trim(law_number) = '42-4-1105(2),(5)(a)'
        # OR trim(law_number) = '42-4-1105(1),(5)(a)'
        # GROUP BY case_number
        
        # SELECT case_year, count(case_year)
        # FROM uniq_sentence
        # group by case_year
    
        year_sentenced <- all_unique_sentence %>% 
          group_by(case_year) %>% 
          summarize(race_sentence_count = n()) 
        
        year_charge %>% inner_join(year_sentenced)
        
        year_charge_sentenced <- year_charge %>% inner_join(year_sentenced)    
        
        year_charge_sentenced %>% write_csv("year_charge_sentenced.csv", na = "")
        
        # Flouirsh graphic made of the charge/sentence by year data: https://public.flourish.studio/visualisation/8803703/

      ########################################################### county calc ###############################################  
        
# By county        
     # charge 
        
        all_unique_charges %>% 
        group_by(county_name) %>% 
          summarize(race_charge_count = n()) %>% 
          arrange(desc(race_charge_count)) %>% 
          View()
        
         # Adams County charged it by far with 503 times   
            # SQL verification:
              # SELECT county_name, count(county_name)
              # FROM uniq_charge
              # group by county_name
              # ORDER BY count(county_name) DESC
        
        county_race_charge <- all_unique_charges %>% 
          group_by(county_name) %>% 
          summarize(race_charge_count = n()) %>% 
          arrange(desc(race_charge_count))
        
        county_race_charge %>% write_csv("county_race_charge.csv", na = "")
    
      # sentence        
        
        all_unique_sentence %>% 
          group_by(county_name) %>% 
          summarize(race_sentence_count = n()) %>% 
          arrange(desc(race_sentence_count)) %>% 
          View()
    
        # SQL:
          # SELECT county_name, count(county_name)
          # FROM uniq_sentence
          # group by county_name
          # ORDER BY count(county_name) DESC
        
        county_race_sentence <- all_unique_sentence %>% 
          group_by(county_name) %>% 
          summarize(race_sentence_count = n()) %>% 
          arrange(desc(race_sentence_count))
        
        county_race_sentence %>% write_csv("county_race_sentence.csv", na = "")
        
        # Instead of taking the time to manually merge each county, a left join is way more efficient 
        
        county_race_charge %>% left_join(county_race_sentence) %>% 
          View()
        
        county_race_charge_sentence <- county_race_charge %>% left_join(county_race_sentence) 
        
          # That worked well. But way to mutate to add percentage between columns 
        
        county_race_charge %>% left_join(county_race_sentence) %>% 
          mutate(race_convict_perc = (race_sentence_count/race_charge_count)*100) %>% 
          View()
        
          # Worked great!!
        
        county_race_sentence_perc <- county_race_charge %>% left_join(county_race_sentence) %>% 
          mutate(convict_perc = (race_sentence_count/race_charge_count)*100)
        
        county_race_sentence_perc %>% write_csv("county_race_sentence_perc.csv", na = "")

        
######################################################## year calc ##############################################        
        
 # By year
    # I did some of this above but I want to do it from scratch to verify it. Same numbers are coming back across R and SQL :)
        
    # Charge    
            
        all_unique_charges %>% 
          group_by(case_year) %>% 
          summarize(street_charge_count = n()) 
        
        year_co_charge <- all_unique_charges %>% 
          group_by(case_year) %>% 
          summarize(street_charge_count = n()) 
        
        # SQL verification:
          # CREATE TABLE uniq_charge as 
          # SELECT distinct trim(case_number), *
          #  FROM street_race_all
          # WHERE trim(law_number) = '42-4-1105(1)'
          # OR trim(law_number) = '42-4-1105'
          # OR trim(law_number) = '42-4-1105(1),(3)'
          # OR trim(law_number) = '42-4-1105(2)'
          # OR trim(law_number) = '42-4-1105(2),(3)'
          # OR trim(law_number) = '42-4-1105(2),(5)(a)'
          # OR trim(law_number) = '42-4-1105(1),(5)(a)'
          # GROUP BY case_number
          
          # SELECT case_year, count(case_year)
          # FROM uniq_charge
          # group by case_year
        
    # Street racing sentence    
        
        all_unique_sentence %>% 
        group_by(case_year) %>% 
          summarize(street_sentence_count = n()) 
        
        year_co_sentence <- all_unique_sentence %>% 
          group_by(case_year) %>% 
          summarize(street_sentence_count = n())
        
        left_join(year_co_charge, year_co_sentence, by = "case_year")
    
        year_co_charge_sentence <- left_join(year_co_charge, year_co_sentence, by = "case_year")    
        
    # Sentenced to a non-street racing charge    
        
        distinct_filtered_non_race_street_race_sentence %>% 
          group_by(case_year) %>% 
          summarize(non_street_sentence_count = n())
 
        # Worked :)
          # SQL verified, although most of this code will make more sense in the non-street racing conviction section below. 
            
                # CREATE TABLE all_sentences AS
                # SELECT *
                #   FROM street_race_all
                # WHERE sentence_penalty_code is not NULL
                
                # CREATE TABLE not_sentence_street_race AS 
                # SELECT DISTINCT case_number
                # FROM (
                #  SELECT *
                #    FROM street_race_all
                #  WHERE sentence_penalty_code is NULL
                # ) as x
                # WHERE
                # trim(law_number) = '42-4-1105(1)'
                # OR trim(law_number) = '42-4-1105'
                # OR trim(law_number) = '42-4-1105(1),(3)'
                # OR trim(law_number) = '42-4-1105(2)'
                # OR trim(law_number) = '42-4-1105(2),(3)'
                # OR trim(law_number) = '42-4-1105(2),(5)(a)'
                # OR trim(law_number) = '42-4-1105(1),(5)(a)'
      
                # CREATE TABLE non_race_street_race_sentence AS
                # SELECT *
                #  FROM all_sentences, not_sentence_street_race
                # WHERE all_sentences.case_number = not_sentence_street_race.case_number
                
                # CREATE TABLE filtered_non_race_street_race_sentence AS
                # SELECT * FROM non_race_street_race_sentence WHERE law_number NOT LIKE '%42-4-1105%'
                
                # CREATE TABLE uniq_non_race_sentence AS
                # SELECT DISTINCT case_number, case_year 
                # FROM (
                #  SELECT *
                #    FROM filtered_non_race_street_race_sentence
                #  WHERE sentence_penalty_code is NOT NULL
                # ) as x
                
                # SELECT case_year, count(case_year)
                # FROM uniq_non_race_sentence
                # group by case_year
      
        distinct_filtered_non_race_street_race_sentence %>% 
          group_by(case_year) %>% 
          summarize(non_street_sentence_count = n())
          
        year_co_non_street_sentence <- distinct_filtered_non_race_street_race_sentence %>% 
          group_by(case_year) %>% 
          summarize(non_street_sentence_count = n())
        
             
        left_join(year_co_charge_sentence, year_co_non_street_sentence, by = "case_year")
        
          # Will need to add together to get total sentenced per year 
        
        year_co_charge_sentence_non_street <- left_join(year_co_charge_sentence, year_co_non_street_sentence, by = "case_year")
        
        year_co_charge_sentence_non_street %>% write_csv("year_co_charge_sentence_non_street.csv", na = "")
        
        
        # See Denver section for Denver sentencing by year 
        
        
 # Of those sentenced
        
        race_jail_pt1 <- race_charge_pt1_7 %>% 
          filter(sentence_penalty_code == "DOC")
        
        race_jail_pt2 <- race_charge_pt1_7 %>% 
          filter(sentence_penalty_code == "JAIL")
        
        race_jail_pt3 <- race_charge_pt1_7 %>% 
          filter(sentence_penalty_code == "CRTS")
        
        race_jail_pt4 <- race_charge_pt1_7 %>% 
          filter(sentence_penalty_code == "YOS")
        
        race_jail_pt5 <- race_charge_pt1_7 %>% 
          filter(sentence_penalty_code == "JVDT")
        
        # Now let's put them all together
        
        race_jail_pt1_2 <- race_jail_pt1 %>% full_join(race_jail_pt2)
        
        race_jail_pt1_3 <- race_jail_pt3 %>% full_join(race_jail_pt1_2)
        
        race_jail_pt1_4 <- race_jail_pt4 %>% full_join(race_jail_pt1_3)
        
        race_jail_pt1_5 <- race_jail_pt5 %>% full_join(race_jail_pt1_4)
        
        
        race_jail_pt1_5 %>% 
          distinct(case_number, .keep_all = TRUE) %>%
          View()
        
        # Of those charged with street racing, only 45 spent any time in jail/prison.
          # SQL verification in two parts:
        
            # CREATE TABLE all_jail AS
            # SELECT *
            #  FROM street_race_all
            # WHERE trim(sentence_penalty_code) = 'DOC'
              # OR trim(sentence_penalty_code) = 'CRTS'
              # OR trim(sentence_penalty_code) = 'JAIL'
              # OR trim(sentence_penalty_code) = 'YOS'
              # OR trim(sentence_penalty_code) = 'JVDT'
              # OR trim(sentence_penalty_code) = 'WCOR'
            
          #  SELECT *
          #    FROM all_jail
          #  WHERE trim(law_number) = '42-4-1105(1)'
          #  OR trim(law_number) = '42-4-1105'
          #  OR trim(law_number) = '42-4-1105(1),(3)'
          #  OR trim(law_number) = '42-4-1105(2)'
          #  OR trim(law_number) = '42-4-1105(2),(3)'
          #  OR trim(law_number) = '42-4-1105(2),(5)(a)'
          #  OR trim(law_number) = '42-4-1105(1),(5)(a)'
          #  GROUP BY case_number
    
       jail_all_unique_sentence <- race_jail_pt1_5 %>% 
          distinct(case_number, .keep_all = TRUE)
        
        (45/376)*100  
        
        (45/2445)*100
        
        (376/2445)*100
          
    # So, 12% of 376 convicted spend time in jail
        # And 2% of 2,445 charged spent time in jail. 
        # 15% of the 2,445 street racing cases statewide from 2016 to 2021 resulted in a conviction. 
     
    # And now jail convictions by county
      
       jail_all_unique_sentence %>% 
          group_by(county_name) %>% 
          summarize(jail_race_sentence_count = n()) %>% 
          View()
        
       # SQL verification in three parts:
       
         # CREATE TABLE all_jail AS
         # SELECT *
         #  FROM street_race_all
         # WHERE trim(sentence_penalty_code) = 'DOC'
         # OR trim(sentence_penalty_code) = 'CRTS'
         # OR trim(sentence_penalty_code) = 'JAIL'
         # OR trim(sentence_penalty_code) = 'YOS'
         # OR trim(sentence_penalty_code) = 'JVDT'
         # OR trim(sentence_penalty_code) = 'WCOR'
         
         # CREATE TABLE jail_street_race_sentence AS
         #  SELECT *
         #    FROM all_jail
         #  WHERE trim(law_number) = '42-4-1105(1)'
         #  OR trim(law_number) = '42-4-1105'
         #  OR trim(law_number) = '42-4-1105(1),(3)'
         #  OR trim(law_number) = '42-4-1105(2)'
         #  OR trim(law_number) = '42-4-1105(2),(3)'
         #  OR trim(law_number) = '42-4-1105(2),(5)(a)'
         #  OR trim(law_number) = '42-4-1105(1),(5)(a)'
         #  GROUP BY case_number
         
          # SQL:
          # SELECT county_name, count(county_name)
          # FROM jail_street_race_sentence
          # group by county_name
          # ORDER BY count(county_name) DESC
          
        jail_county_race_sentence <- jail_all_unique_sentence %>% 
          group_by(county_name) %>% 
          summarize(jail_race_sentence_count = n()) 
        
        jail_county_race_sentence %>% write_csv("jail_county_race_sentence.csv", na = "")
        jail_county_race_sentence %>% write_csv("jail_county_race_sentence.csv", na = "")
        # Instead of taking the time to manually merge each county, a left join is way more efficient 
        
        county_race_sentence_perc %>% left_join(jail_county_race_sentence) %>% 
          View()
        
        
        # That worked well. But way to mutate to add percentage between columns 
        
        county_race_sentence_perc %>% left_join(jail_county_race_sentence) %>%  
          mutate(jail_convict_perc = (jail_race_sentence_count/race_sentence_count)*100) %>% 
          View()
        
        # This worked great again!!
        
        jail_county_race_sent_perc <- county_race_sentence_perc %>% left_join(jail_county_race_sentence) %>%  
          mutate(jail_convict_perc = (jail_race_sentence_count/race_sentence_count)*100) %>% 
          View()
        
        jail_county_race_sent_perc %>% write_csv("jail_county_race_sent_perc.csv", na = "")
        

# Analyze by judicial officer
        
        
            
# So when a case is charged with street racing, what else are they charged with? Sentenced on?
        # Visual representation of joins: https://www.codeproject.com/Articles/33052/Visual-Representation-of-SQL-Joins 
        
    
        street_race_all %>% 
          distinct(case_number, .keep_all = TRUE)
        
        # 2,796 unique rows for all cases in data
        
        race_charge_pt1_7 %>% 
          distinct(case_number, .keep_all = TRUE) 
        
        # 2,445 unique cases with a speed race charge
        
        street_race_all %>% inner_join(race_charge_pt1_7) %>% 
          View()
        
        # If goal is to see what else cases were sentenced on if charged with street racing, need to pull out all cases with a sentence and see how it compares to street race cases
        
        street_race_all %>% 
          filter(!is.na(sentence_penalty_code)) %>% 
          View()
        
         # New data frame and then do a join
        
        sentence_street_race_all <- street_race_all %>% 
          filter(!is.na(sentence_penalty_code))
        
        #  24,553 rows
            
        sentence_street_race_all %>% inner_join(race_charge_pt1_7) %>% 
          View()
        
        sentence_street_race_all %>% inner_join(race_charge_pt1_7) %>% 
          group_by(law_description) %>% 
          summarize(law_description_count = n()) %>% 
          arrange(desc(law_description_count)) %>%
          View()
        
          # That didn't work because it looks like the only thing that was included is if a street race charge occurred. Not sure where the other charges went. 
        
        # anti join?
        anti_join(sentence_street_race_all, race_charge_pt1_7) %>% 
          distinct(case_number, .keep_all = TRUE) %>% 
          group_by(law_description) %>% 
          summarize(count = n()) %>% 
          arrange(desc(count)) %>% 
          View()
        
        # Above worked but I don't think it answers the question that I'm asking. Anti-join shows what's in table X that's not in table Y.
        
        inner_join(sentence_street_race_all, race_charge_pt1_7) %>% 
          group_by(law_description) %>% 
          summarize(count = n()) %>% 
          arrange(desc(count)) %>% 
          View()
        
        # Ugh. And this only showed speed racing charges again
        
        
        # Left join?
          # Want stuff that;s in all sentence AND street race sentence
        
        sentence_street_race_all %>% left_join(race_charge_pt1_7) %>%
          View()
        
          # Not sure if results of left join are showing when a street race charge occured 
            # What if I created a mutate indicator for race charge?
            # Or join on just case numbers?
        
        
        left_join(sentence_street_race_all, race_charge_pt1_7, by = "case_number") %>% 
          View()
        
        inner_join(sentence_street_race_all, race_charge_pt1_7, by = "case_number") %>% 
          View()
        
        # I think that worked? Would need to only select columns that had charge of speed racing, aka table y
        
        left_join(sentence_street_race_all, race_charge_pt1_7, by = "case_number") %>% 
          View()
        
        # Wait - holy fucking shit there is a "charge finding" column! 
          # DMDA - dismissed???
          # Noticed it in this case number: 	
            # C0302016T 000356
       
        race_charge_pt1_7 %>% 
          group_by(charge_finding) %>% 
          summarize(count = n()) %>% 
          arrange(desc(count)) %>% 
          View()
        
        # Worked. Leading category is DMDA, or dismissed by DA per court doc "Finding Codes with Definition."
          # So in theory, we could see what they WERE sentenced to from after doing another merge
          # Let's run same query as above but limit it to distinct cases 
          # If charge_finding column is blank, case may be too recent to have a conclusion in the data. 
        
        race_charge_pt1_7 %>% 
        distinct(case_number, .keep_all = TRUE) %>% 
          group_by(charge_finding) %>% 
          summarize(count = n()) %>% 
          arrange(desc(count)) %>% 
          View()
        
        # Need to recode to make more sense of what I am looking at 
        
          race_charge_pt1_7 %>% 
          mutate(charge_finding =
                   recode(charge_finding,
                          `DISS` = "Deferred Sentence Complete",
                          `DMDA` = "Dismissed by DA",
                          `FFGY` = "Guilty",
                          `DMCT` = "Dismissed by Court",
                          `FDFS` = "Deferred Sentence",
                          `ACQT` = "Acquitted",
                          `CNSD` = "Consolidated")) %>% 
          View()
        
          # Recode worked great. Will apply changes to dataframe and go from there. 
            # Format:
            # warn20 <- warn20 %>% 
            #  mutate(layoff_type =
            #           recode(type_code,
            #                  `1` = "Plant Closure",
            #                  `2` = "Mass Layoff"))
            
          # Got this weird error: 
            # Error in UseMethod("mutate") : 
            # no applicable method for 'mutate' applied to an object of class "NULL"
          # Restarted R and it went away. NewsNerdery had other ideas for next time: 
              # forcats::fct_recode() does basically the same thing, but it's a newer, more modern function, and it's optimized for working with strings/factors while dplyr::recode() is generalized.
          
   library(tidyverse)       
         
          race_charge_pt1_7 <- race_charge_pt1_7 %>% 
            mutate(charge_code =
            recode(charge_finding,
              `DISS` = "Deferred Sentence Complete",
             `DMDA` = "Dismissed by DA",
             `FFGY` = "Guilty",
                 `DMCT` = "Dismissed by Court",
              `FDFS` = "Deferred Sentence",
              `ACQT` = "Acquitted",
               `CNSD` = "Consolidated"))
          
          # tweak column name 
          
          race_charge_pt1_7 <- race_charge_pt1_7 %>% 
            mutate(charge_finding_explanation =
                         recode(charge_finding,
                                `DISS` = "Deferred Sentence Complete",
                                `DMDA` = "Dismissed by DA",
                                `FFGY` = "Guilty",
                                `DMCT` = "Dismissed by Court",
                                `FDFS` = "Deferred Sentence",
                                `ACQT` = "Acquitted",
                                `CNSD` = "Consolidated"))
        
          # drop extra column
          
          select(race_charge_pt1_7, -c(charge_code)) %>% 
            View()
          
          # Alright! We are now off to the races. 
         
           race_charge_pt1_7 %>% 
            distinct(case_number, .keep_all = TRUE) %>% 
            group_by(charge_finding_explanation) %>% 
            summarize(count = n()) %>% 
            arrange(desc(count))
        
           # Street racing charges were dismissed by the DA 1,731 times. Dismissed by the court another 69 times. 
           
           # charge_finding_explanation   count
           # Dismissed by DA             1731
           # Guilty                       287
           # NA                           278
           # Dismissed by Court            69
           # Deferred Sentence Complete    56
           # Deferred Sentence             17
           # Acquitted                      3
           # FDIV                           3
           # Consolidated                   1
           
            # I searched in my email and I got an updated Findings Codes and Definitions sheet from the court. FDIV = Diversion. 
              # "Court accepts and enters into a diversion agreement with defendant or juvenile."
           
           # Ok - So if the courts or the DA dismissed a charge, what were they sentenced for?
           
            # Dismissed by DA: 
           
             dismissed_race_charge_pt1 <- race_charge_pt1_7 %>% 
             filter(charge_finding_explanation == "Dismissed by DA") 
           
             # Dismissed by courts:
             
            dismissed_race_charge_pt2 <- race_charge_pt1_7 %>% 
              filter(charge_finding_explanation == "Dismissed by Court")  
           
            # Put together:
            
            dismissed_race_charge_pt1_2 <- dismissed_race_charge_pt1 %>% full_join(dismissed_race_charge_pt2)
            
            # Now let's try a left join. I want to see what's in dismissed race and also sentenced. 
            
            dismissed_race_charge_pt1_2 %>% left_join(sentence_street_race_all) %>% 
              View()
        
            dismissed_race_charge_pt1_2 %>% full_join(sentence_street_race_all) %>% 
              View()
            
              # Closer. See C0032017T 001890 as good example. Maybe need to do full join where sentence is not null again.
            
            dismissed_race_charge_pt1_2 %>% full_join(sentence_street_race_all) %>% 
              filter(!is.na(sentence_penalty_code)) %>%
               View()
            
              # That is better, but I don't get the difference between the finding codes and the plea codes? I am confused as to how someone could both have a charge dismissed by a DA and plead guilty. I want to make sure I am being as accurate as possible and putting the court's data in proper context.
                # I asked Rob McCallum and Jon Sarche about it.
                # This is for case number: C0032020T 003860
     
      ####################  non-street race convict  ###################################          
           
            # BRINGING OVER EVERYTHING FROM street_race_3.2_dismissed.R TO HAVE IT ALL IN ONE PLACE
            
             # Street racing charges that didn't lead to sentence:
            
            race_charge_pt1_7 %>% 
              filter(is.na(sentence_penalty_code)) %>% 
              distinct(case_number, .keep_all = TRUE) %>% 
              View()
            
            # 2,110 rows
              # Good cases to check: C0512016T 002627
                # SQL verified - 2110 rows. This is just a list of case numbers, which will turn out to be helpful later. 
                # CREATE TABLE not_sentence_street_race AS 
                # SELECT DISTINCT case_number
                # FROM (
                #  SELECT *
                #    FROM street_race_all
                #  WHERE sentence_penalty_code is NULL
                # ) as x
                # WHERE
                # trim(law_number) = '42-4-1105(1)'
                # OR trim(law_number) = '42-4-1105'
                # OR trim(law_number) = '42-4-1105(1),(3)'
                # OR trim(law_number) = '42-4-1105(2)'
                # OR trim(law_number) = '42-4-1105(2),(3)'
                # OR trim(law_number) = '42-4-1105(2),(5)(a)'
                # OR trim(law_number) = '42-4-1105(1),(5)(a)'
            
            not_sentenced_street_race <- race_charge_pt1_7 %>% 
              filter(is.na(sentence_penalty_code)) %>% 
              distinct(case_number, .keep_all = TRUE)
            
            # Just case_numbers:
            
            not_sentenced_street_race %>% 
              select(case_number) %>% 
              View()
            
            case_num_not_sentenced_street_race <- not_sentenced_street_race %>% 
              select(case_number)
            
            # SQL for all race charges (equivalent of race_charge_pt1_7)     
            
            # # SELECT distinct trim(case_number), *
            # FROM street_race_all
            # WHERE trim(law_number) = '42-4-1105(1)'
            # OR trim(law_number) = '42-4-1105'
            # OR trim(law_number) = '42-4-1105(1),(3)'
            # OR trim(law_number) = '42-4-1105(2)'
            # OR trim(law_number) = '42-4-1105(2),(3)'
            # OR trim(law_number) = '42-4-1105(2),(5)(a)'
            # OR trim(law_number) = '42-4-1105(1),(5)(a)'
            # GROUP BY case_number
            
            # All sentenced cases in the raw data
            
            sentence_street_race_all <- street_race_all %>% 
              filter(!is.na(sentence_penalty_code))
            
            # Got different number of rows in SQL, will check:
            
            sum(!is.na(street_race_all$sentence_penalty_code))
            
            # Nope. Still 20322 rows . SQL has 24k+
            
            street_racing_010116_123121_4 %>% 
              filter(!is.na(sentence_penalty_code))
            
            # On a fresh import I got 24,535 rows, the same as SQL. others in News Nerdery and Lonely Coders Club got the same thing in R and Excel. 
            # SQL code verifies it, 24,535 rows: 
            # SELECT *
            #  FROM street_racing_all
            # WHERE sentence_penalty_code is not NULL
            
            sentence_street_race_all <- street_racing_010116_123121_4 %>% 
              filter(!is.na(sentence_penalty_code))
            
            # Try inner join with all cases with a sentence with street race cases without a sentence
            
            inner_join(case_num_not_sentenced_street_race, sentence_street_race_all, by = "case_number") %>% 
              View()
            
            # Missing the cases with a sentence, I think I need to do an inverse
            
            inner_join(sentence_street_race_all, case_num_not_sentenced_street_race, by = "case_number") %>% 
              View()
            
            # HALLELUJAH IT WORKED!!!!!!!!!!!!!!!!!!!!
            
            # SQL verified!
            #  For all sentences, regardless of whether it involved street racing:
            # CREATE TABLE all_sentences AS
            # SELECT *
            #   FROM street_racing_all
            # WHERE sentence_penalty_code is not NULL
            
            # For all case numbers for street racing charges that DID NOT result in a sentence: 
            # CREATE TABLE not_sentence_street_race AS 
            # SELECT DISTINCT case_number
            # FROM (
            #  SELECT *
            #    FROM street_racing_all
            #  WHERE sentence_penalty_code is NULL
            # ) as x
            # WHERE
            # trim(law_number) = '42-4-1105(1)'
            # OR trim(law_number) = '42-4-1105'
            # OR trim(law_number) = '42-4-1105(1),(3)'
            # OR trim(law_number) = '42-4-1105(2)'
            # OR trim(law_number) = '42-4-1105(2),(3)'
            # OR trim(law_number) = '42-4-1105(2),(5)(a)'
            # OR trim(law_number) = '42-4-1105(1),(5)(a)'
            
            # To merge:
            # SELECT *
            #   FROM all_sentences, not_sentence_street_race
            # WHERE all_sentences.case_number = not_sentence_street_race.case_number
            
            # SQL merge has 18,120 rows. R has same result.
            
            non_race_street_race_sentence <- inner_join(sentence_street_race_all, case_num_not_sentenced_street_race, by = "case_number")
            
            non_race_street_race_sentence %>% write_csv("non_race_street_race_sentence.csv", na = "")
            
            # What type of charge most common?
            
            non_race_street_race_sentence %>% 
              group_by(law_description) %>% 
              summarize(law_description_count = n()) %>% 
              arrange(desc(law_description_count)) %>%
              View()
            
            # It looks like the last query picked up speed contest/exhibition sentences when it shouldn't have if there was a limited instance where a spped contest/exhibition/facilitating was dismissed as a component of the sentence. 
            # Will do anti-join so street racing cases aren't in there 
            
            case_num_race_charge_pt1_7 <- race_charge_pt1_7 %>% 
              select(case_number) 
            
            anti_join(case_num_race_charge_pt1_7, non_race_street_race_sentence, by = "case_number") %>% 
              View()
            
            anti_join(non_race_street_race_sentence, case_num_race_charge_pt1_7, by = "case_number") %>% 
              View()
            # That didn't work lol
            # anti-join doesn't get rid of street racing cases, just tells you what's not in Table B if anti-joined with Table A. 
            
            non_race_street_race_sentence %>% 
              filter(!(law_number == "42-4-1105")) %>% 
              View()
            
            # Above did work. Will have another law number for street racing to filter out other street racing statutes 
            
            # race_charge_pt1 <- street_race_all %>% 
            #  filter(law_number == "42-4-1105") 
            
            # race_charge_pt2 <-  street_race_all %>% 
            #  filter(law_number == "42-4-1105(1)") 
            
            # race_charge_pt3 <-  street_race_all %>% 
            #  filter(law_number == "42-4-1105(1),(3)") 
            
            # race_charge_pt4 <-  street_race_all %>% 
            #   filter(law_number == "42-4-1105(2)") 
            
            # race_charge_pt5 <-  street_race_all %>% 
            #   filter(law_number == "42-4-1105(2),(3)") 
            
            #  race_charge_pt6 <-  street_race_all %>% 
            #   filter(law_number == "42-4-1105(2),(5)(a)") 
            
            # race_charge_pt7 <-  street_race_all %>% 
            #   filter(law_number == "42-4-1105(1),(5)(a)")
            
            non_race_street_race_sentence %>% 
              filter(!(law_number == "42-4-1105"|law_number == "42-4-1105(1)"|law_number == "42-4-1105(1),(3)"|law_number == "42-4-1105(2)"|law_number == "42-4-1105(2),(3)"|law_number == "42-4-1105(2),(5)(a)"|law_number == "42-4-1105(1),(5)(a)")) %>% 
              View()
            
            # Oh hell yeah! That worked 
            
            filtered_non_race_street_race_sentence <- non_race_street_race_sentence %>% 
              filter(!(law_number == "42-4-1105"|law_number == "42-4-1105(1)"|law_number == "42-4-1105(1),(3)"|law_number == "42-4-1105(2)"|law_number == "42-4-1105(2),(3)"|law_number == "42-4-1105(2),(5)(a)"|law_number == "42-4-1105(1),(5)(a)"))
            
            # 17,517 rows
            # Same as this SQL query: SELECT * FROM non_race_street_race_sentence WHERE law_number NOT LIKE '%42-4-1105%'
            # And this:
            # SELECT *
            #  FROM non_race_street_race_sentence
            # WHERE trim(law_number) != "42-4-1105(1)"
            # AND trim(law_number) != "42-4-1105(2)"
            # Used AND and not OR because:
            # Basically "not this id OR not this id" will always be true for a set of unique ids (everything is either one or the other!), so nothing gets filtered. try swapping that OR for AND?
            
            
            # Let's break it into chunks and then full join to make sure I'm doing this correctly. 
            # Pulling != from here: https://www.statmethods.net/management/operators.html
            
            # Maybe it would make more sense to add together the total number of rows to see how much should be subtracted and then do an anti-join to see which rows aren't in either
            
            extra_street_in_non_street_pt1 <- non_race_street_race_sentence %>% 
              filter(law_number == "42-4-1105") 
            
            # No rows under that statute. 
            
            extra_street_in_non_street_pt2 <- non_race_street_race_sentence %>% 
              filter(law_number == "42-4-1105(1)") 
            
            # 249 rows here
            
            extra_street_in_non_street_pt3 <- non_race_street_race_sentence %>%  
              filter(law_number == "42-4-1105(1),(3)") 
            
            # No rows under that statute.  
            
            extra_street_in_non_street_pt4 <- non_race_street_race_sentence %>%  
              filter(law_number == "42-4-1105(2)") 
            
            extra_street_in_non_street_pt5 <- non_race_street_race_sentence %>%  
              filter(law_number == "42-4-1105(2),(3)") 
            
            extra_street_in_non_street_pt6 <- non_race_street_race_sentence %>% 
              filter(law_number == "42-4-1105(2),(5)(a)") 
            
            extra_street_in_non_street_pt7 <- non_race_street_race_sentence %>% 
              filter(law_number == "42-4-1105(1),(5)(a)") 
            
            
            extra_street_in_non_street_pt1_2 <- extra_street_in_non_street_pt1 %>% full_join(extra_street_in_non_street_pt2)
            
            extra_street_in_non_street_pt1_3 <- extra_street_in_non_street_pt3 %>% full_join(extra_street_in_non_street_pt1_2)
            
            extra_street_in_non_street_pt1_4 <- extra_street_in_non_street_pt4 %>% full_join(extra_street_in_non_street_pt1_3)
            
            extra_street_in_non_street_pt1_5 <- extra_street_in_non_street_pt5 %>% full_join(extra_street_in_non_street_pt1_4)
            
            extra_street_in_non_street_pt1_6 <- extra_street_in_non_street_pt6 %>% full_join(extra_street_in_non_street_pt1_5)
            
            extra_street_in_non_street_pt1_7 <- extra_street_in_non_street_pt7 %>% full_join(extra_street_in_non_street_pt1_6)
            
            #  extra_street_in_non_street_pt1_7 has 603 rows that need to be eliminated.   
            
            18120 - 603 = 17517
            
            # So subtracting 603 rows from 18,120 rows from non_race_street_race_sentence equals 17,517 rows. 
            # So this has been verified three different ways. :) 
            
            
            # Now let's see what we're working with. How often are there convictions when it's not for street racing?
            
            filtered_non_race_street_race_sentence %>% 
              group_by(law_description) %>% 
              summarize(law_description_count = n()) %>% 
              arrange(desc(law_description_count)) %>%
              View()
            
            # Worked, but counted every aspect of the sentence instead of distinct cases with a sentence. See below for number of unique case numbers in each category.    
            # Verified by SQL:
            
            # CREATE TABLE filtered_non_race_street_race_sentence AS
            # SELECT *
            #   FROM non_race_street_race_sentence
            # WHERE trim(law_number) != "42-4-1105(1)"
            # AND trim(law_number) != "42-4-1105(2)"
            
            # SELECT law_description, count(law_description)
            # FROM filtered_non_race_street_race_sentence
            # GROUP BY law_description
            # ORDER BY count(law_description) DESC 
            
            # For distinct:
            
            distinct_filtered_non_race_street_race_sentence <- filtered_non_race_street_race_sentence %>% 
              distinct(case_number, .keep_all = TRUE)
            
            # Now grouped and by distinct cases: 
            
            filtered_non_race_street_race_sentence %>% 
              distinct(case_number, .keep_all = TRUE) %>% 
              group_by(law_description) %>% 
              summarize(law_description_count = n()) %>% 
              arrange(desc(law_description_count)) %>% 
              View()
            
            
            # Most common conviction, if not street racing, is reckless/careless driving and driving while ability impaired. 
            # Reckless driving was the most common sentence. 305 times (turned out to be 312, see below). 
            # LET'S TEST THAT THEORY OUT TO MAKE SURE
            # Pulling out just reckless driving sentences by unique case number:
            
            filtered_non_race_street_race_sentence %>% 
              distinct(case_number, .keep_all = TRUE) %>% 
              filter(law_description == "RECKLESS DRIVING")
            
            # Checks out! 305 rows, just like the overall group-by theory above. 
            # For SQL comparison:
            
            r_reckless_driving <- filtered_non_race_street_race_sentence %>% 
              distinct(case_number, .keep_all = TRUE) %>% 
              filter(law_description == "RECKLESS DRIVING")
            
            filtered_non_race_street_race_sentence %>% 
              distinct(case_number, .keep_all = TRUE) %>% 
              filter(law_description == "RECKLESS DRIVING")
            
            
            # Pulling out just careless driving sentences by unique case number:
            
            filtered_non_race_street_race_sentence %>% 
              distinct(case_number, .keep_all = TRUE) %>% 
              filter(law_description == "CARELESS DRIVING")
            
            # Works again! 193 rows for careless driving (actually 207, see below). 
            
            # Pulling out just SPEEDING 10-19 OVER LIMIT sentences by unique case number:
            
            filtered_non_race_street_race_sentence %>% 
              distinct(case_number, .keep_all = TRUE) %>% 
              filter(law_description == "SPEEDING 10-19 OVER LIMIT")
            
            # Works thrice! 167 rows for careless driving (actually 170, see below).
            
            # BUT -- There's a weird difference by a few rows between the totals for reckless driving, careless driving, etc between R and SQL analysis of cases that not convicted of street racing but are convicted of something else. . 
            # SO will do a set_diff to see what's different
            
            setdiff(sql_reckless_driving, r_reckless_driving)
            
            # Number of columns have to match between tables for a setdiff to work, let's do an anti-join
            
            anti_join(sql_reckless_driving, r_reckless_driving)
            
            # The results are 7 different cases in the SQL query that appear to have a reckless driving charg within the filtered non-race data. Not sure why SQL picked up on it but R didn't
            # So that means by initial R approach is inaccurate if I am missing pertinent cases in the data
            # This is how I pulled out the data for SQL: 
            
            # CREATE TABLE uniq_non_race_sentence2 AS
            # SELECT DISTINCT case_number, law_number, law_description, county_name 
            # FROM (
            #   SELECT *
            #     FROM filtered_non_race_street_race_sentence
            #   WHERE sentence_penalty_code is NOT NULL
            # ) as x
            
            # SELECT *
            #   FROM uniq_non_race_sentence2
            # WHERE law_description = "RECKLESS DRIVING"
            
            filtered_non_race_street_race_sentence %>% 
              unique(case_number) %>% 
              group_by(law_description) %>% 
              summarize(law_description_count = n()) %>% 
              arrange(desc(law_description_count)) %>% 
              View()
            
            
            filtered_non_race_street_race_sentence %>% 
              group_by(case_number, law_description) %>% 
              View()
            
            filtered_non_race_street_race_sentence %>% 
              group_by(case_number, law_description) %>% 
              summarize(law_description_count = n()) %>% 
              View()
            
            # Trying to group by both case number and count:
            
            filtered_non_race_street_race_sentence %>% 
              group_by(case_number, law_description) %>% 
              summarize(count_sentence_component = n()) %>% 
              View()
            
            # Does summarizing make a difference:
            
            filtered_non_race_street_race_sentence %>% 
              group_by(case_number, law_description) %>% 
              summarize(count_sentence_component = n()) %>% 
              View()
            
            filtered_non_race_street_race_sentence %>% 
              group_by(case_number, law_description) %>% 
              View()
            
            # Yes, without it  -- everything falls apart, not truly grouped. 
            
            filtered_non_race_street_race_sentence %>% 
              group_by(case_number, law_description) %>% 
              summarize(count_sentence_component = n()) %>% 
              arrange(case_number) %>% 
              View()
            
            # Comes up multiple times for different sentences, so I think it worked: 
            # C0012017M 005232
            # C0032020T 000238
            
            grouped_filtered_non_race_street_race_sentence <- filtered_non_race_street_race_sentence %>% 
              group_by(case_number, law_description) %>% 
              summarize(count_sentence_component = n()) %>% 
              arrange(case_number)
            
            # And let's test it - 
            
            grouped_filtered_non_race_street_race_sentence %>% 
              group_by(law_description) %>% 
              summarize(law_description_count = n()) %>% 
              arrange(desc(law_description_count)) %>% 
              View()
            
            # Works!! 
            # So if a case did not have a street racing sentence, these were the most common charges they were sentenced under:
            
                # law_description                  law_description_count
                # RECKLESS DRIVING                                   312
                # CARELESS DRIVING                                   207
                # SPEEDING 10-19 OVER LIMIT                          170
            
            sentenced_type_non_race_street_race_statewide_minus_denver <- grouped_filtered_non_race_street_race_sentence %>% 
              group_by(law_description) %>% 
              summarize(law_description_count = n()) %>% 
              arrange(desc(law_description_count))
            
            sentenced_type_non_race_street_race_statewide_minus_denver %>% write_csv("sentenced_type_non_race_street_race_statewide_minus_denver.csv", na = "")
            
            # SQL verification:
            
                # CREATE TABLE uniq_non_race_sentence2 AS
                # SELECT DISTINCT case_number, law_number, law_description, county_name 
                # FROM (
                #   SELECT *
                #     FROM filtered_non_race_street_race_sentence
                #   WHERE sentence_penalty_code is NOT NULL
                # ) as x
                
                # SELECT law_description, count(law_description)
                # FROM uniq_non_race_sentence2
                # GROUP BY law_description
                # ORDER BY count(law_description) DESC 
            
            
            # How many additional convictions happened outside of street racing ones?
            
            filtered_non_race_street_race_sentence %>% 
              distinct(case_number, .keep_all = TRUE) %>% 
              View()
            
            # 1,560 distinct cases with a sentence for a crime other than street racing. 
            # Verified in SQL, 1560 rows:
            # SELECT DISTINCT case_number
            # FROM (
            #  SELECT *
            #    FROM filtered_non_race_street_race_sentence
            #  WHERE sentence_penalty_code is NOT NULL
            # ) as x
            
            # As a reminder, there are 376 unique street racing convictions. 
            # And 2,445 street racing cases:
            
            race_charge_pt1_7 %>% 
              distinct(case_number, .keep_all = TRUE)
            
            # So - if 15% of street racing cases end up in a street racing conviction, how many cases overall end up with a conviction?
            
            ((1560+376)/2445)*100
            
            # 79% of cases overall get some kind of conviction. 
            
            # Will need to work Denver cases into this somehow. 
            
            # By county for other charges?
            
            filtered_non_race_street_race_sentence %>% 
              distinct(case_number, .keep_all = TRUE) %>% 
              group_by(county_name) %>% 
              summarize(race_sentence_count = n()) %>% 
              arrange(desc(race_sentence_count)) %>% 
              View()
            
            # Adams County has the most, with 342 convictions for charges besides street racing in street racing cases. 
            # Verified by SQL: 
            
            # CREATE TABLE filtered_non_race_street_race_sentence AS
            # SELECT trim(case_number) as "trim_case_number", *
            #   FROM non_race_street_race_sentence
            # WHERE trim(law_number) != "42-4-1105(1)"
            # AND trim(law_number) != "42-4-1105(2)"
            
            # CREATE TABLE uniq_cases_filtered AS
            # SELECT DISTINCT case_number, county_name, case_judicial_officer_bar_number
            # FROM (
            #   SELECT *
            #     FROM filtered_non_race_street_race_sentence
            #   WHERE sentence_penalty_code is NOT NULL
            # ) as x  
            
            #  SELECT county_name, count(county_name)
            # FROM uniq_cases_filtered
            # group by county_name
            # ORDER BY count(county_name) DESC  
            
            
            # New data frame:
            
            county_nonrace_sentence <- filtered_non_race_street_race_sentence %>% 
              distinct(case_number, .keep_all = TRUE) %>% 
              group_by(county_name) %>% 
              summarize(race_sentence_count = n()) %>% 
              arrange(desc(race_sentence_count))
            
              # Merge it with out county data:
                # template: county_race_sentence_perc %>% left_join(jail_county_race_sentence)
              
               jail_county_race_sent_perc %>% left_join(county_nonrace_sentence) %>% 
                View()
            
                # Not giving the 7th column that it should.
               
                # Does flipping it help?
                 
               county_nonrace_sentence %>% left_join(jail_county_race_sent_perc) %>% 
                 View()
            
               # That didn't work. Still get capped at 6 columns for some reason.
               
               # Let's switch up the format.
                # Structure: left_join(x,y, by = "Flag")
                # Source: https://stackoverflow.com/questions/32066402/how-to-perform-multiple-left-joins-using-dplyr-in-r
               
               left_join(jail_county_race_sent_perc, county_nonrace_sentence, by = "county_name") %>% 
                 View()
               
               # That worked :)
               
               non_street_race_county_race_sent <- left_join(jail_county_race_sent_perc, county_nonrace_sentence, by = "county_name") %>% 
                 
               
            # But did any of those sentenced for other charges spend time in jail?
            
            jail_pt1_filtered_non_race_street_race_sentence <- filtered_non_race_street_race_sentence %>% 
              filter(sentence_penalty_code == "DOC")
            
            jail_pt2__filtered_non_race_street_race_sentence <- filtered_non_race_street_race_sentence %>% 
              filter(sentence_penalty_code == "JAIL")
            
            jail_pt3__filtered_non_race_street_race_sentence <- filtered_non_race_street_race_sentence %>% 
              filter(sentence_penalty_code == "CRTS")
            
            jail_pt4__filtered_non_race_street_race_sentence <- filtered_non_race_street_race_sentence %>% 
              filter(sentence_penalty_code == "YOS")
            
            jail_pt5__filtered_non_race_street_race_sentence <- filtered_non_race_street_race_sentence %>% 
              filter(sentence_penalty_code == "JVDT")
            
            # Now let's put them all together
            
            filtered_non_race_street_race_sentence_jail_pt1_2 <- jail_pt1_filtered_non_race_street_race_sentence %>% full_join(jail_pt2__filtered_non_race_street_race_sentence)
            
            filtered_non_race_street_race_sentence_jail_pt1_3 <- jail_pt3__filtered_non_race_street_race_sentence %>% full_join(filtered_non_race_street_race_sentence_jail_pt1_2)
            
            filtered_non_race_street_race_sentence_jail_pt1_4 <- jail_pt4__filtered_non_race_street_race_sentence %>% full_join(filtered_non_race_street_race_sentence_jail_pt1_3)
            
            filtered_non_race_street_race_sentence_jail_pt1_5 <- jail_pt5__filtered_non_race_street_race_sentence %>% full_join(filtered_non_race_street_race_sentence_jail_pt1_4)
            
            # 478 charges that led to jail time, not sure how many unique cases in that position. 
            # SQL verification (still 478 rows):
            # SELECT *
            # FROM filtered_non_race_street_race_sentence
            # WHERE trim(sentence_penalty_code) = 'DOC'
            # OR trim(sentence_penalty_code) = 'CRTS'
            # OR trim(sentence_penalty_code) = 'JAIL'
            # OR trim(sentence_penalty_code) = 'YOS'
            # OR trim(sentence_penalty_code) = 'JVDT'
            # OR trim(sentence_penalty_code) = 'WCOR'
            
            # Type of charges that led to jail time?
            
            filtered_non_race_street_race_sentence_jail_pt1_5 %>%  
              group_by(law_description) %>% 
              summarize(jail_count = n()) %>% 
              arrange(desc(jail_count))
            
            # Reckless driving came up the most, but looks like lots of case repeats in the data.
            # SQL verified:
            # SELECT law_description, count(law_description)
            # FROM jail_filtered_non_race_street_race_sentence
            # GROUP BY law_description
            # ORDER BY count(law_description) DESC
            
            # Unique cases:
            
            jail_non_race_sentence <- filtered_non_race_street_race_sentence_jail_pt1_5 %>% 
              distinct(case_number, .keep_all = TRUE) %>% 
              View()
            
            # 281 unique cases led to jail time 
            # SQL verified, 281 cases:
            
            # CREATE TABLE jail_filtered_non_race_street_race_sentence AS
            # SELECT *
            #  FROM filtered_non_race_street_race_sentence
            # WHERE trim(sentence_penalty_code) = 'DOC'
            # OR trim(sentence_penalty_code) = 'CRTS'
            # OR trim(sentence_penalty_code) = 'JAIL'
            # OR trim(sentence_penalty_code) = 'YOS'
            # OR trim(sentence_penalty_code) = 'JVDT'
            # OR trim(sentence_penalty_code) = 'WCOR'  
            
            # SELECT DISTINCT case_number
            # FROM jail_filtered_non_race_street_race_sentence
            
            # Unique cases jailed:
            
            jail_non_race_sentence %>% 
              group_by(law_description) %>% 
              summarize(jail_count = n()) %>% 
              arrange(desc(jail_count))
            
            # I want to see if the similar theory as above would work. I want to get one row for each charge put in jail for, even if a case number has multiple lines. 
            # Going for results that this SQL query gets:
            
            # CREATE TABLE filtered_non_race_street_race_sentence AS
            # SELECT trim(case_number) as "trim_case_number", *
            #   FROM non_race_street_race_sentence
            # WHERE trim(law_number) != "42-4-1105(1)"
            # AND trim(law_number) != "42-4-1105(2)"
            
            # CREATE TABLE jail_filtered_non_race_street_race_sentence AS
            # SELECT *
            #   FROM filtered_non_race_street_race_sentence
            # WHERE trim(sentence_penalty_code) = 'DOC'
            # OR trim(sentence_penalty_code) = 'CRTS'
            # OR trim(sentence_penalty_code) = 'JAIL'
            # OR trim(sentence_penalty_code) = 'YOS'
            # OR trim(sentence_penalty_code) = 'JVDT'
            # OR trim(sentence_penalty_code) = 'WCOR'
            
            # SELECT DISTINCT case_number, law_description
            # FROM jail_filtered_non_race_street_race_sentence
            
            jail_non_race_sentence %>% 
              group_by(case_number, law_description) %>% 
              summarize(jail_count = n()) %>% 
              arrange(case_number) %>% 
              View()
            
            jail_non_race_sentence %>%
              select(case_number, law_description) %>% 
              distinct(case_number, law_description, .keep_all = TRUE) %>% 
              View()
            
            # Above both left out some rows. SQL query has 293 rows. 
            
            filtered_non_race_street_race_sentence_jail_pt1_5 %>% 
              group_by(case_number, law_description) %>% 
              summarize(count_sentence_component = n()) %>% 
              arrange(case_number) %>% 
              View()
            
            # WORKED!!! 293 rows. 
            # Test case was D0622016CR001397, which has two rows for both vehicle eluding and driving under the influence. 
            # Another test cases, D0212016CR000333, also worked well. Returns three rows for each charge that led to jail time. 
            # I don't know why this worked. All I changed was going back to the original data frame that it came from. Worked so whatever. 
            
            # Use query on line 593 to calculate revised number of charges that led to jail time now that unnecessary rows have been eliminated:
            
            library(tidyverse)
            
            jailed_non_street_racing <- filtered_non_race_street_race_sentence_jail_pt1_5 %>% 
              group_by(case_number, law_description) %>% 
              summarize(count_sentence_component = n()) %>% 
              arrange(case_number)
            
            # Now let's see the charges that you're more likely to be jailed on with street racing:
            
            jailed_non_street_racing %>% 
              group_by(law_description) %>% 
              summarize(jail_count = n()) %>% 
              arrange(desc(jail_count)) %>% 
              View()
            
            # Driving while ability impaired (Aka drinking and driving) was the most common type of charge. A couple variations to look out for. 
            
            # SQL verified:
            
            # CREATE TABLE filtered_non_race_street_race_sentence AS
            # SELECT trim(case_number) as "trim_case_number", *
            #   FROM non_race_street_race_sentence
            # WHERE trim(law_number) != "42-4-1105(1)"
            # AND trim(law_number) != "42-4-1105(2)"
            
            # CREATE TABLE jail_filtered_non_race_street_race_sentence AS
            # SELECT *
            #   FROM filtered_non_race_street_race_sentence
            # WHERE trim(sentence_penalty_code) = 'DOC'
            # OR trim(sentence_penalty_code) = 'CRTS'
            # OR trim(sentence_penalty_code) = 'JAIL'
            # OR trim(sentence_penalty_code) = 'YOS'
            # OR trim(sentence_penalty_code) = 'JVDT'
            # OR trim(sentence_penalty_code) = 'WCOR'
            
            # CREATE TABLE charge_jail_nonrace AS
            # SELECT DISTINCT case_number, law_description
            # FROM jail_filtered_non_race_street_race_sentence
            
            # SELECT law_description, count(law_description)
            # FROM charge_jail_nonrace
            # GROUP BY law_description
            # ORDER BY count(law_description) DESC
            
            # Driving while ability impaired was the most-likely charge in six years to lead to jail time (59 times). 
            # Followed closely by reckless driving.            
            
       # Now I need to pull out the cases with a conviction for a non-speed race related charge that led to jail by county           
            
            jail_non_race_sentence %>% 
              group_by(county_name) %>% 
              summarize(race_sentence_count = n()) %>% 
              arrange(desc(race_sentence_count))
        
            # Adams County has the most cases with people that went to jail with a non-street race charge. 
              # SQL verified, 44 cases in Adams county:
              
              # CREATE TABLE filtered_non_race_street_race_sentence AS
              # SELECT trim(case_number) as "trim_case_number", *
              #   FROM non_race_street_race_sentence
              # WHERE trim(law_number) != "42-4-1105(1)"
              # AND trim(law_number) != "42-4-1105(2)"
            
              # CREATE TABLE jail_filtered_non_race_street_race_sentence AS
              # SELECT *
              #  FROM filtered_non_race_street_race_sentence
              # WHERE trim(sentence_penalty_code) = 'DOC'
              # OR trim(sentence_penalty_code) = 'CRTS'
              # OR trim(sentence_penalty_code) = 'JAIL'
              # OR trim(sentence_penalty_code) = 'YOS'
              # OR trim(sentence_penalty_code) = 'JVDT'
              # OR trim(sentence_penalty_code) = 'WCOR'  
              
              # CREATE TABLE non_race_street_race_sentence2 AS
              # SELECT DISTINCT case_number, county_name
              # FROM jail_filtered_non_race_street_race_sentence
              
              # SELECT county_name, COUNT(county_name)
              # FROM non_race_street_race_sentence2
              # GROUP BY county_name
              # ORDER BY COUNT(county_name) DESC
            
            # Now let's merge again so all in one table
            
            county_jail_non_race_sentence <- jail_non_race_sentence %>% 
              group_by(county_name) %>% 
              summarize(race_sentence_count = n()) %>% 
              arrange(desc(race_sentence_count))
            
            non_street_race_county_race_sent  
            
            left_join(non_street_race_county_race_sent, county_jail_non_race_sentence, by = "county_name") %>% 
              View()
           
            county_merge_jail_non_race_sentence <- left_join(non_street_race_county_race_sent, county_jail_non_race_sentence, by = "county_name")
            
            county_merge_jail_non_race_sentence %>% write_csv("county_merge_jail_non_race_sentence.csv", na = "")
            
              # Will need to go back and add Denver totals to Denver district
             
#############################################################################      denver ####################      
                        
# Denver case count:
        
            library(tidyverse)
            
            denver_cases <- denver_street_racing_data_all_cases    

            denver_cases %>% 
              distinct(case_no, .keep_all = TRUE) %>% 
              View()
                        
            # 581 Denver county street racing cases
              # Denver statutes has a drag racing statute on the books, 54-159: http://denver-co.elaws.us/code/coor_ch54_artvi_div2_sec54-159
              # SQL verified: 
              
                # SELECT DISTINCT case_no
                # FROM denver_street_racing_data_all_cases
                
            # How many guilty?
            
            denver_cases %>% 
              filter(case_outcome == "GUILTY") %>% 
              distinct(case_no, .keep_all = TRUE)
            
              # 76 of just GUILTY, but I don't think that captures everything (weird labels, see below. More accurate number is at row 875)
            
            # Cases that have been a guilty and a guilty/amended?
            
            denver_cases %>% 
              filter(case_outcome == "GUILTY" & case_outcome == "GUILTY/AMENDED") 
            
            # No instance of that being a thing where both guilty AND guilty/amended.
              # Kristin Wood, with Denver Courts, explained that: 
                # Any "guilty/amended" category is indeed guilty of the labeled law. I was worried that it was an indicator of being guilty of a different charge for some reason. She said that is not the case.
            
            # Instances where it's either type of guilty:
            
            denver_cases %>% 
              filter(case_outcome == "GUILTY"|case_outcome == "GUILTY/AMENDED" ) %>% 
              distinct(case_no, .keep_all = TRUE)
            
            # 121 distinct cases.
              # Verified by SQL:
                # SELECT DISTINCT case_no, *
                # FROM denver_street_racing_data_all_cases
                # WHERE case_outcome = "GUILTY"
                # OR case_outcome = "GUILTY/AMENDED"
                # GROUP BY case_no
            
              denver_guilty_cases <- denver_cases %>% 
                filter(case_outcome == "GUILTY"|case_outcome == "GUILTY/AMENDED" ) %>% 
                distinct(case_no, .keep_all = TRUE)
            
            # Dismissed? 
              
              denver_cases %>% 
                filter(case_outcome == "DISMISSED") %>% 
                distinct(case_no, .keep_all = TRUE)
            
              # Need to loop in the dismissed/amended cases too
              
                denver_cases %>% 
                  filter(case_outcome == "DISMISSED"|case_outcome == "DISMISSED/AMENDED" ) %>% 
                  distinct(case_no, .keep_all = TRUE)
              
                  # 508 dismissed cases
                    # SQL verified, 508 dismissed cases: 
                    
                      # SELECT DISTINCT case_no, *
                      #  FROM denver_street_racing_data_all_cases
                      # WHERE case_outcome = "DISMISSED"
                      # OR case_outcome = "DISMISSED/AMENDED"
                      # GROUP BY case_no
                
                  denver_dismissed_cases <- denver_cases %>% 
                    filter(case_outcome == "DISMISSED"|case_outcome == "DISMISSED/AMENDED" ) %>% 
                    distinct(case_no, .keep_all = TRUE)
                
              # Any cases with both a dismissal and guilty?  
                
                  inner_join(denver_dismissed_cases, denver_guilty_cases, "case_no")
                  
                  # Yes, 48 cases where one street racing charge was dismissed but was found guilty of another. 
                      # So - I need to take the percentage out of the overall total. Not compared together. 
                    # SQL verified: 
                  
                     # CREATE TABLE denver_dismissed AS
                     # SELECT DISTINCT case_no, *
                     #   FROM denver_street_racing_data_all_cases
                     # WHERE case_outcome = "DISMISSED"
                     # OR case_outcome = "DISMISSED/AMENDED"
                     # GROUP BY case_no
                  
                     # CREATE TABLE denver_guilty AS
                     # SELECT DISTINCT case_no, *
                     #   FROM denver_street_racing_data_all_cases
                     # WHERE case_outcome = "GUILTY"
                     # OR case_outcome = "GUILTY/AMENDED"
                     # GROUP BY case_no
                    
                    # And INNER JOIN: 
                      # SELECT denver_dismissed.case_no, denver_guilty.case_no, denver_dismissed.defendant, denver_guilty.defendant, denver_dismissed.law_description as "dismissed_charge", denver_guilty.law_description as "guilty_charge", denver_dismissed.offense_date 
                      # FROM denver_dismissed, denver_guilty
                      # WHERE denver_dismissed.case_no = denver_guilty.case_no
                  
              # Any other outcomes in the data?
              
              denver_cases %>% 
                distinct(case_no, .keep_all = TRUE) %>% 
                group_by(case_outcome) %>% 
                summarize(case_outcome_count = n()) %>% 
                arrange(desc(case_outcome))
                
              # There's some weird labels that I asked Kristin Wood, with Denver courts, to provide an explanation for.
                # What is the difference if a case is guilty/amended compared to guilty? Or dismissed/amended vs dismissed?
                # Kristin Wood, with Denver Courts, explained that: 
                  # Any "guilty/amended" category is indeed guilty of the labeled law. I was worried that it was an indicator of being guilty of a different charge for some reason. She said that is not the case.
              
              
              denver_cases %>% 
              group_by(case_outcome) %>% 
                summarize(case_outcome_count = n()) %>% 
                arrange(desc(case_outcome))
              
            # Well, if a case is in the sentence data then we can pull conclusions from that. 
              
              denver_sentence <- denver_street_racing_data_sentence
                
              denver_sentence %>%               
                distinct(case_no, .keep_all = TRUE)
                
              # 73 cases with a sentence. 
              
              denver_sentence %>% 
                distinct(case_no, .keep_all = TRUE) %>% 
                group_by(sentence) %>% 
                summarize(sentence_count = n()) %>% 
                arrange(desc(sentence)) %>% 
                View()
                
                # Most common type of sentence was defensive driving school with 44
                  # Unsure if there were other components of the sentence 
              
              # How many spent time in jail?
              
                denver_sentence %>% 
                  distinct(case_no, .keep_all = TRUE) %>% 
                  group_by(jail) %>% 
                  summarize(jail_count = n()) %>% 
                  arrange(desc(jail)) %>% 
                  View()
                
                # Wrote formula to pull out the word "jail" in sentence and clean more thoroughly in that Excel:
                  # =IF(ISNUMBER(SEARCH("JAIL",E2)), "Yes", "No")
                
                  denver_street_racing_data_sentence %>% 
                    distinct(trim(case_no, .keep_all = TRUE)) %>% 
                    filter(jail == "Yes") %>% 
                    View()
                
                  # Keeps returning different results than SQL. Not sure why.
                  
                  denver_street_racing_data_sentence %>% 
                    filter(jail == "Yes") %>% 
                    View()
                  
                  denver_street_racing_data_sentence %>% 
                    filter(jail == "Yes") %>% 
                    group_by(case_no) %>% 
                    summarize(jail_count = n()) %>% 
                    arrange(desc(jail_count)) %>%
                    View()
                 
                  # Above worked!
                    # SQL verified: 
                      # SELECT DISTINCT case_no
                      # FROM denver_street_racing_data_sentence
                      # WHERE jail = "Yes"
                  
                # 10 cases, of 73, spent time in jail.
                
            # We have names here. Any repeats?
              # Cases  
                
                denver_cases %>%
                  distinct(case_no, .keep_all = TRUE) %>% 
                  group_by(defendant) %>% 
                  summarize(defendant_count = n()) %>% 
                  arrange(desc(defendant)) %>% 
                  View()
                
          # Got the additional data on 03/24 for other charges that folks were also charged with 
                library(tidyverse)
                
                denver_street_all <- denver_street_racing_other_charges_convictions_3
                
                denver_street_all %>% 
                  distinct(case_no, .keep_all = TRUE)
              
                # There are still 581 distinct cases here, which is a good sign. 
                  # It is the same number of distinct cases in the original data (see above).
                
                denver_street_all %>% 
                filter(crs == "42-4-1105(1)"|crs == "42-4-1105(1),(3)"|crs == "42-4-1105(2)"|crs == "42-4-1105(2),(3)"|crs == "54-159") %>% 
                  distinct(case_no, .keep_all = TRUE)
                
                  # When pull out just street racing, still 581 distinct rows. That is good.
                
                # So we will pull out just guilty or guilty/amended:
                
                  denver_street_all %>%
                    filter(disposition == "GUILTY"|disposition == "GUILTY/AMENDED" ) %>% 
                    View()
                
                  # 992 rows. Same as in SQL:
                  
                    # CREATE TABLE denver_guilty AS
                    # SELECT *
                    #  FROM denver_street_all
                    # WHERE disposition = "GUILTY"
                    #  OR disposition = "GUILTY/AMENDED"
                
                  denver_guilty <- denver_street_all %>%
                    filter(disposition == "GUILTY"|disposition == "GUILTY/AMENDED" )
                
                # Distinct guilty cases of street racing:  
                    
                  denver_guilty %>% 
                    filter(crs == "42-4-1105(1)"|crs == "42-4-1105(1),(3)"|crs == "42-4-1105(2)"|crs == "42-4-1105(2),(3)"|crs == "54-159") %>% 
                    distinct(case_no, .keep_all = TRUE)
                
                  # 121 cases still, same as previous data. This is a god sign that this data is exactly what we thought it would be. No cases have been added.  
                  
                  distinct_denver_guilty <- denver_guilty %>% 
                    filter(crs == "42-4-1105(1)"|crs == "42-4-1105(1),(3)"|crs == "42-4-1105(2)"|crs == "42-4-1105(2),(3)"|crs == "54-159") %>% 
                    distinct(case_no, .keep_all = TRUE)
                
                    # To find out how many per year:
                      # Inspo: https://tidyr.tidyverse.org/reference/separate.html 
                      
                      year_sep_distinct_denver_guilty <- distinct_denver_guilty %>% 
                        separate(offense_date, c("month", "day", "year"))
                      
                      year_sep_distinct_denver_guilty %>% 
                        group_by(year) %>% 
                        summarize(street_sentence_count = n()) 
                  
                      grouped_year_sep_distinct_denver_guilty <- year_sep_distinct_denver_guilty %>% 
                        group_by(year) %>% 
                        summarize(street_sentence_count = n())  
                    
                      # SQL:
                        # CREATE TABLE distinct_denver_guilt AS
                        # SELECT DISTINCT case_no, year
                        # FROM denver_guilty
                        # WHERE trim(crs) = "42-4-1105(1)"
                        # OR trim(crs) = "42-4-1105(1),(3)"
                        # OR trim(crs) = "42-4-1105(2)"
                        # OR trim(crs) = "42-4-1105(2),(3)"
                        # OR trim(crs) = "54-159"
                        # GROUP BY case_no
                        
                        # Didn't work:
                        # SELECT year, count(year)
                        # FROM distinct_denver_guilt
                        # GROUP BY year
                        
                      # That is different than what SQL is saying.So am going to do a left join and see what's up 
                        #These numbers actually check out. Was a problem with formula pulling out year in Denver excel 
                      
                      # CREATE TABLE denver_guilty AS
                      # SELECT *
                      #   FROM denver_street_all
                      # WHERE disposition = "GUILTY"
                      # OR disposition = "GUILTY/AMENDED"
                      
                      # CREATE TABLE distinct_denver_guilt AS
                      # SELECT DISTINCT case_no, year
                      # FROM denver_guilty
                      # WHERE trim(crs) = "42-4-1105(1)"
                      # OR trim(crs) = "42-4-1105(1),(3)"
                      # OR trim(crs) = "42-4-1105(2)"
                      # OR trim(crs) = "42-4-1105(2),(3)"
                      # OR trim(crs) = "54-159"
                      # GROUP BY case_no
                      
                      # SELECT year, count(year)
                      # FROM distinct_denver_guilt
                      # GROUP BY year
                      
                     # Fact-check (problem solved, but this was the process):
                       # Pull out 2016 in R to compare to SQL
                      
                        # R pull out for 2016
                        
                        r_den_sentence_2016_test <- year_sep_distinct_denver_guilty %>% 
                            filter(year == "2016")
                        
                        
                        sql_den_sentence_2016_test <- den_sentence_2016_test
                        
                        # Let's try to join 
                        
                          left_join(r_den_sentence_2016_test, sql_den_sentence_2016_test, by = "case_no")
                          
                          left_join(sql_den_sentence_2016_test, r_den_sentence_2016_test, by = "case_no")
                        
                          # didn't work
                          
                          # anti-join-- 
                          
                          anti_join(r_den_sentence_2016_test, sql_den_sentence_2016_test, by = "case_no")
                        
                            # worked. difference of 5 cases.
                          
                              # D050398 coming up as 2021 in SQL as a false 2016 for some reason. Looks like a filter error. 
                                # Turns out that the formula to pull out just the year didn't work. 
                                  # Falsely inserted "2016" as year when there were other years involved.
                                  # I think it was a weird bit of formatting in Excel that caused it. Ran this through again and it seemed to rectify the issue:
                                    # =TEXT(C2,"YYYY")
                        
           # Denver street racing charges that didn't lead to sentence:
                
                  # Dismissed:
                  
                  denver_dismissed <- denver_street_all %>%
                    filter(disposition == "DISMISSED"|disposition == "DISMISSED/AMENDED" )
                  
                  # Street racing charges that were dismissed:
                  
                  denver_dismissed %>% 
                  filter(crs == "42-4-1105(1)"|crs == "42-4-1105(1),(3)"|crs == "42-4-1105(2)"|crs == "42-4-1105(2),(3)"|crs == "54-159")
                    
                  # Worked! 883 rows. 
                  
                  # Let's check it with a roundabout method:
                  
                      denver_dismissed_pt1 <-  denver_dismissed %>% 
                        filter(crs == "42-4-1105(1)")
                      
                      denver_dismissed_pt2 <-  denver_dismissed %>% 
                        filter(crs == "42-4-1105(1),(3)") 
                      
                      denver_dismissed_pt3 <-  denver_dismissed %>% 
                        filter(crs == "42-4-1105(2)") 
                      
                      denver_dismissed_pt4 <-  denver_dismissed %>% 
                        filter(crs == "42-4-1105(2),(3)") 
                      
                      denver_dismissed_pt5 <-  denver_dismissed %>% 
                        filter(crs == "54-159")  
                  
                        # Full join test:
                         # Inspo: https://dplyr.tidyverse.org/reference/mutate-joins.html
                        
                        # So let's move the full join down below. We will merge all of the tables together when it is done. 
                        
                          denver_dismissed_pt1_2 <- denver_dismissed_pt1 %>% full_join(denver_dismissed_pt2)
                          
                          denver_dismissed_pt1_3 <- denver_dismissed_pt3 %>% full_join(denver_dismissed_pt1_2)
                          
                          denver_dismissed_pt1_4 <- denver_dismissed_pt4 %>% full_join(denver_dismissed_pt1_3)
                          
                          denver_dismissed_pt1_5 <- denver_dismissed_pt5 %>% full_join(denver_dismissed_pt1_4)
                        
                        
                  # Just want one line per case:
                  
                    denver_dismissed_street_race <- denver_dismissed %>% 
                      distinct(case_no, .keep_all = TRUE) %>% 
                      filter(crs == "42-4-1105(1)"|crs == "42-4-1105(1),(3)"|crs == "42-4-1105(2)"|crs == "42-4-1105(2),(3)"|crs == "54-159")
                  
                        # 318 lines
                          # This doesn't match with SQL. 
                          # Ran into similar issue in project trying to do it all at once. 
                          # Fixed it by doing the piecemeal full_join approach. That is the most accurate way to do it. 
                    
                    denver_dismissed_pt1_5 %>% 
                      distinct(case_no, .keep_all = TRUE)
                    
                      # 508 lines. 
                        # SQL verified, 508 unique cases:
                    
                          # CREATE TABLE denver_dismissed AS
                          # SELECT *
                          #   FROM denver_street_all
                          # WHERE disposition = "DISMISSED"
                          #  OR disposition = "DISMISSED/AMENDED"
                    
                         # SELECT DISTINCT trim(case_no)
                         # FROM denver_dismissed
                         # WHERE trim(crs) = "42-4-1105(1)"
                         # OR trim(crs) = "42-4-1105(1),(3)"
                         # OR trim(crs) = "42-4-1105(2)"
                         # OR trim(crs) = "42-4-1105(2),(3)"
                         # OR trim(crs) = "54-159"
                    
                    
                  # Only want unique case numbers:
                  
                    denver_dismissed_pt1_5 %>% 
                    select(case_no) %>% 
                    distinct(case_no, .keep_all = TRUE)
                    
                    case_num_denver_dismissed_street_race <- denver_dismissed_pt1_5 %>% 
                      select(case_no) %>% 
                      distinct(case_no, .keep_all = TRUE)
                    
                    # From previous query with too few rows not verifiedd by SQL, steer clear:
                      denver_dismissed_street_race %>% 
                      select(case_no) %>% 
                        View()
                      
                      case_num_denver_dismissed_street_race <- denver_dismissed_street_race %>% 
                        select(case_no)
                  
                  # Joined back with cases with a sentence and what they were sentenced for via inner join:
                   
                      inner_join(denver_guilty, case_num_denver_dismissed_street_race, by = "case_no") %>% 
                        View()
                  
                    # Code holds up for Denver data too :) 
                      # SQL verified, 858 rows:
                      
                          # CREATE TABLE denver_guilty AS
                          # SELECT *
                          #   FROM denver_street_all
                          # WHERE disposition = "GUILTY"
                          # OR disposition = "GUILTY/AMENDED"
                      
                         # CREATE TABLE case_num_denver_dismissed2 AS
                         # SELECT DISTINCT case_no
                         # FROM denver_dismissed
                         # WHERE trim(crs) = "42-4-1105(1)"
                           # OR trim(crs) = "42-4-1105(1),(3)"
                           # OR trim(crs) = "42-4-1105(2)"
                           # OR trim(crs) = "42-4-1105(2),(3)"
                           # OR trim(crs) = "54-159"
                      
                         # SELECT *
                         #   FROM denver_guilty, case_num_denver_dismissed2
                         # WHERE denver_guilty.case_no = case_num_denver_dismissed2.case_no
                          
                      denver_non_race_street_race_sentence <- inner_join(denver_guilty, case_num_denver_dismissed_street_race, by = "case_no")
                      
                      # Remember - need to filter out street racing again in case one instance of it was dismissed while found guilty of another. 
                      
                        denver_non_race_street_race_sentence %>% 
                          filter(!(crs == "42-4-1105(1)"|crs == "42-4-1105(1),(3)"|crs == "42-4-1105(2)"|crs == "42-4-1105(2),(3)"|crs == "54-159")) %>% 
                          View()
                        
                       #Prev:  filtered_denver_non_race_street_race_sentence <- denver_non_race_street_race_sentence %>% 
                              # filter(!(crs == "42-4-1105(1)"|crs == "42-4-1105(1),(3)"|crs == "42-4-1105(2)"|crs == "42-4-1105(2),(3)"|crs == "54-159"))
                        
                          # Getting weird results not matching with SQL here. So -- going to do similar series of full joins and then an anti join
                        
                            den_extra_street_in_non_street_pt1 <- denver_non_race_street_race_sentence %>% 
                              filter(crs == "42-4-1105(1)") 
                            
                            # No rows under that statute. 
                            
                            den_extra_street_in_non_street_pt2 <- denver_non_race_street_race_sentence %>% 
                              filter(crs == "42-4-1105(1),(3)") 
                            
                            # 0 rows here
                            
                            den_extra_street_in_non_street_pt3 <- denver_non_race_street_race_sentence %>% 
                              filter(crs == "42-4-1105(2)")  
                            
                              # 56 rows under that statute.  
                            
                            den_extra_street_in_non_street_pt4 <- denver_non_race_street_race_sentence %>% 
                              filter(crs == "42-4-1105(2),(3)") 
                            
                            den_extra_street_in_non_street_pt5 <- denver_non_race_street_race_sentence %>% 
                              filter(crs == "54-159") 
                        
                          # Now merge: 
                            
                            den_extra_street_in_non_street_pt1_2 <- den_extra_street_in_non_street_pt1 %>% full_join(den_extra_street_in_non_street_pt2)
                        
                            den_extra_street_in_non_street_pt1_3 <- den_extra_street_in_non_street_pt3 %>% full_join(den_extra_street_in_non_street_pt1_2)
                        
                            den_extra_street_in_non_street_pt1_4 <- den_extra_street_in_non_street_pt4 %>% full_join(den_extra_street_in_non_street_pt1_3)
                        
                            den_extra_street_in_non_street_pt1_5 <- den_extra_street_in_non_street_pt5 %>% full_join(den_extra_street_in_non_street_pt1_4)
                        
                          # And anti-join:
                            # Similar format: denver_non_race_street_race_sentence <- inner_join(denver_guilty, case_num_denver_dismissed_street_race, by = "case_no")
                            
                            anti_join(denver_non_race_street_race_sentence, den_extra_street_in_non_street_pt1_5, by = "case_no")
                        
                              # Somehow still returns 492 cases, same as before. Still different from SQL though
                                # I think this eliminating more than what I need. I want it to just get rid of the rows that mention street racing. Not the cases overall because it could be a sentence for a different charge and we want that. 
                                # If a case is found guilty for street racing, we would document it in a different section of the data. We are looking at cases where they are not guilty of street racing but are guilty of something else. 
                                # Spotcheck of the eliminated 82 rows did not find them guilty of a different crime in this data. So that is reassuring. 
                            
                          # Try a different way, one statute at a time
                            # Starts at 858 rows
                            
                            denver_non_race_street_race_sentence %>% 
                              filter(!(crs == "42-4-1105(1)"))
                            
                           filter_1_denver_non_race_street_race_sentence <- denver_non_race_street_race_sentence %>% 
                             filter(!(crs == "42-4-1105(1)"))
                           
                           filter_1_2_denver_non_race_street_race_sentence <- filter_1_denver_non_race_street_race_sentence %>% 
                             filter(!(crs == "42-4-1105(2)"))
                           
                            # Now it's down to 776
                           
                           filter_1_3_denver_non_race_street_race_sentence <- filter_1_2_denver_non_race_street_race_sentence %>% 
                             filter(!(crs == "42-4-1105(1),(3)"))
                           
                            # Still at 776
                            
                           filter_1_4_denver_non_race_street_race_sentence <- filter_1_3_denver_non_race_street_race_sentence %>% 
                             filter(!(crs == "42-4-1105(2),(3)"))
                           
                            # After 4 rounds, still 776
                           
                           filter_1_5_denver_non_race_street_race_sentence <- filter_1_4_denver_non_race_street_race_sentence %>% 
                             filter(!(crs == "54-159"))
                           
                           # I think this is what we need to stick with. A manual check of denver_non_race_street_race_sentence for rows with a variety of 42-4-1105 shows 82 rows. 
                            # Nothing under 54-159.
                            # As I said above:
                              # If a case is found guilty for street racing, we would document it in a different section of the data. We are looking at cases where they are not guilty of street racing but are guilty of something else. 
                              # Spot check of the eliminated 82 rows did not find them guilty of a different crime in this data. So that is reassuring. 
                            
                          # SQL verified: 
                           # SELECT *
                           #  FROM denver_non_race_street_race_sentence
                           # WHERE trim(crs) != "42-4-1105(1)"
                             # AND trim(crs) != "42-4-1105(1),(3)"
                             # AND trim(crs) != "42-4-1105(2)"
                             # AND trim(crs) != "42-4-1105(2),(3)"
                             # AND trim(crs) != "54-159"
                           
                        # Frequency of charges people are convicted of if they aren't convicted of street racing:
                        
                          filter_1_5_denver_non_race_street_race_sentence %>% 
                            group_by(`crs description`) %>% 
                            summarize(sentence_count = n()) %>% 
                            View()
                          
                          # Reckless and careless driving are the most common categories. Same as the state as a whole.
                            # Will need to combine this with statewide numbers to get overall numbers. 
                        
                          # SQL verified: 
                          
                            # SELECT crsdescription, count(crsdescription)
                            # FROM filtered_denver_non_race_street_race_sentence
                            # GROUP BY crsdescription
                            # ORDER BY count(crsdescription) DESC
                          
                          denver_sentenced_type_non_race_street_race <- filter_1_5_denver_non_race_street_race_sentence %>% 
                            group_by(`crs description`) %>% 
                            summarize(sentence_count = n())
                          
                          denver_sentenced_type_non_race_street_race %>% write_csv("denver_sentenced_type_non_race_street_race.csv", na = "")
                          
                      # Now let's see how many unique cases there are:
                        
                          filter_1_5_denver_non_race_street_race_sentence %>% 
                        distinct(case_no, .keep_all = TRUE)
                        
                          # 428 cases with a conviction that wasn't convicted for a street racing charge but was convicted of something else. 
                          
                            # SQL verified:
                              # SELECT DISTINCT case_no
                              # FROM filtered_denver_non_race_street_race_sentence
                          
                          # When did these 428 additional sentences happen? Need to pull out these other sentences by year in a different column
                        
                          uniq_filter_1_5_denver_non_race_street_race_sentence <- filter_1_5_denver_non_race_street_race_sentence %>% 
                            distinct(case_no, .keep_all = TRUE)
                          
                          library(stringr)
                          library(tidyverse)
                            
                          uniq_filter_1_5_denver_non_race_street_race_sentence %>% 
                            substr(offense_date,1,5)
                          
                            # Didn;t work
                          
                            uniq_filter_1_5_denver_non_race_street_race_sentence %>% 
                              separate(offense_date, c("A", "B", "C"))
                            
                            # Above worked well. Will tweak column names
                              # Inspo: https://tidyr.tidyverse.org/reference/separate.html 
                          
                          
                            uniq_filter_1_5_denver_non_race_street_race_sentence %>% 
                              separate(offense_date, c("month", "day", "year"))
                            
                            # Worked great!
                            
                            year_sep_uniq_filter_1_5_denver_non_race_street_race_sentence <- uniq_filter_1_5_denver_non_race_street_race_sentence %>% 
                              separate(offense_date, c("month", "day", "year"))
                            
                            year_sep_uniq_filter_1_5_denver_non_race_street_race_sentence %>% 
                             group_by(year) %>% 
                             summarize(non_street_sentence_count = n()) 
                            
                           # year  non_street_sentence_count
                           # 2016                         94
                           # 2017                         59
                           # 2018                         74
                           # 2019                         53
                           # 2020                        102
                           # 2021                         46
                            
                          # LEFT join on earlier sentences to put Denver all in one place  
                            
                            grouped_year_sep_uniq_filter_1_5_denver_non_race_street_race_sentence <- year_sep_uniq_filter_1_5_denver_non_race_street_race_sentence %>% 
                              group_by(year) %>% 
                              summarize(non_street_sentence_count = n()) 
                            
                            left_join(grouped_year_sep_distinct_denver_guilty, grouped_year_sep_uniq_filter_1_5_denver_non_race_street_race_sentence, by = "year")
                            
                            
                            year_denver_sentence <- left_join(grouped_year_sep_distinct_denver_guilty, grouped_year_sep_uniq_filter_1_5_denver_non_race_street_race_sentence, by = "year")
                            
                            # Exported as CSV here:
                            
                            year_denver_sentence %>% write_csv("year_denver_sentence.csv", na = "")
                            
                              # Shit I need charges by year too 
                            
                                # Denver charges
                                
                              denver_distinct_street_charges <- denver_street_all %>% 
                                filter(crs == "42-4-1105(1)"|crs == "42-4-1105(1),(3)"|crs == "42-4-1105(2)"|crs == "42-4-1105(2),(3)"|crs == "54-159") %>% 
                                distinct(case_no, .keep_all = TRUE)
                              
                                year_sep_denver_distinct_street_charges <- denver_distinct_street_charges %>% 
                                  separate(offense_date, c("month", "day", "year"))
                                
                                year_sep_denver_distinct_street_charges %>% 
                                  group_by(year) %>% 
                                  summarize(street_charge_count = n()) 
                                
                                grouped_year_sep_denver_distinct_street_charges <- year_sep_denver_distinct_street_charges %>% 
                                  group_by(year) %>% 
                                  summarize(street_charge_count = n()) 
                                
                                # All worked. Now let's join. 
                                
                                left_join(year_denver_sentence, grouped_year_sep_denver_distinct_street_charges, by = "year")
                                
                                  # Worked swimmingly 
                                
                                year_denver_sentence_charge <- left_join(year_denver_sentence, grouped_year_sep_denver_distinct_street_charges, by = "year")
                                
                                # Unique case count per year in Denver verified by SQL:
                                
                                    # CREATE TABLE distinct_denver_case AS
                                    # SELECT DISTINCT case_no, year
                                    # FROM denver_street_all
                                    # WHERE trim(crs) = "42-4-1105(1)"
                                    # OR trim(crs) = "42-4-1105(1),(3)"
                                    # OR trim(crs) = "42-4-1105(2)"
                                    # OR trim(crs) = "42-4-1105(2),(3)"
                                    # OR trim(crs) = "54-159"
                                    # GROUP BY case_no
                                   
                                    # SELECT year, count(year)
                                    # FROM distinct_denver_case
                                    # GROUP BY year
                                
                                # So will export now:
                                
                                  year_denver_sentence_charge %>% write_csv("year_denver_sentence_charge.csv", na = "")
                            
                     # How many of those spent time in jail?
                          
                          filter_1_5_denver_non_race_street_race_sentence %>% 
                            distinct(case_no, .keep_all = TRUE) %>% 
                            filter(jail == "Yes") %>% 
                            group_by(case_no) %>% 
                            summarize(jail_count = n()) %>% 
                            arrange(desc(jail_count)) %>%
                            View()
                          
                          # 19 rows
                            # Nope, SQL has 44
                          
                          uniq_filter_1_5_denver_non_race_street_race_sentence <- filter_1_5_denver_non_race_street_race_sentence %>% 
                            distinct(case_no, .keep_all = TRUE)
                          
                          uniq_filter_1_5_denver_non_race_street_race_sentence %>% 
                            filter(jail == "Yes")
                          
                          # SQL is picking up on some rows with jail that R may have filtered out because of the distinct clause. Going to try working backwards with all guilty first. 
                            # Case example: 16M01433
                          
                            filter_1_5_denver_non_race_street_race_sentence %>% 
                              filter(jail == "Yes") %>% 
                              distinct(case_no, .keep_all = TRUE) 
                              
                            # That fixed it! Now 44 rows. My problem was that I was eliminating repeat columns before telling R to look for "Yes" in the jail column. I needed to look for yes first and then eliminate. 
                            
                              # Verified through two ways in SQL:
                                # Option 1:
                                  SELECT DISTINCT case_no
                                  FROM filtered_denver_non_race_street_race_sentence
                                  WHERE jail = "Yes"
                              
                                # Option 2:
                                  # create table jail_nonstreet AS
                                  # SELECT DISTINCT case_no, jail
                                  # FROM filtered_denver_non_race_street_race_sentence
                            
                                  # SELECT *
                                  #  FROM jail_nonstreet
                                  # WHERE jail = "Yes"
                                  
                                  
                          
                          
                        
                