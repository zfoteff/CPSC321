
import mysql.connector
import config

def main():
    try: 
        # connection info
        usr = config.mysql['user']
        pwd = config.mysql['password']
        hst = config.mysql['host']
        dab = usr + 'DB'

        # create a connection
        con = mysql.connector.connect(user=usr,password=pwd, host=hst,
                                      database=dab)
        # get a category from the user
        pepper = raw_input('Please enter your favorite pepper: ')
        heat = raw_input('Please enter the heat level: ')

        # insert the pepper into the db
        insert = 'INSERT INTO pepper(common_name,heat) VALUES (%s, %s)'
        rs = con.cursor()
        rs.execute(insert, (pepper, heat))
        # commit the changes
        con.commit()

        # updating the db
        pepper = raw_input('Please enter a pepper to change: ')
        heat = raw_input('Please enter a new heat value: ')
        update = 'UPDATE pepper SET heat=%s WHERE common_name=%s'
        rs.execute(update, (heat, pepper))
        # commit the changes
        con.commit()

        # remove from the db
        pepper = raw_input('Please enter a pepper to remove: ')
        delete = 'DELETE FROM pepper WHERE common_name=%s'
        rs.execute(delete, (pepper,))
        # commit the changes
        con.commit()        

        rs.close()
        con.close()
        
    except mysql.connector.Error as err:
        print err


if __name__ == '__main__':
    main()
    
