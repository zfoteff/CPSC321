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
        # create a result set
        rs = con.cursor()
        query = 'SELECT category_id, name from category'
        # execute the query
        rs.execute(query)
        # print the results
        for (catid, cname) in rs:
            print ("{}, {}".format(catid, cname))

        rs.close()
        con.close()
        
    except mysql.connector.Error as err:
        print (err)


if __name__ == '__main__':
    main()
    
