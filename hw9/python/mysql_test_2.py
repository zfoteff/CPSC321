
import mysql.connector
import config

def main():
    try: 
        # connection info
        usr = config.mysql['user']
        pwd = config.mysql['password']
        hst = config.mysql['host']
        dab = 'cpsc321'
        # create a connection
        con = mysql.connector.connect(user=usr,password=pwd, host=hst,
                                      database=dab)
        # get a category from the user
        user_input_1 = raw_input('Please enter a category id: ')
        user_input_2 = raw_input('Please enter a title keyword: ') 

        # create and execute query
        rs = con.cursor()
        query = '''SELECT COUNT(*) as total 
                   FROM   film_category JOIN film USING (film_id) 
                   WHERE  category_id = %s AND INSTR(title, %s)'''
        rs.execute(query, (user_input_1, user_input_2.upper()))

        # print the result
        row = rs.fetchone()
        if row is not None:
            result = 'There are {} films with category id {} '
            result += 'and titles containing "{}".'
            result = result.format(row[0], user_input_1, user_input_2)
            print result

        rs.close()
        con.close()
            
    except mysql.connector.Error as err:
        print err


if __name__ == '__main__':
    main()
    
