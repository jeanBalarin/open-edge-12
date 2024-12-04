/*********************************************************************************
arquivo..: dsCustomerOrder.i
Autor....: Jean Marcos 
Objetivo.: Dataset para Customer
**********************************************************************************/

{includes/customer.i}
{includes/order.i}
{includes/orderLine.i}

DEFINE DATASET dsCustomerOrder SERIALIZE-HIDDEN
    FOR tt-customer, tt-order, tt-orderline
    DATA-RELATION custOrder FOR tt-customer, tt-order
        RELATION-FIELDS(custNum, custNum)
            NESTED   // aninha os objetos em cada objeto pai
                FOREIGN-KEY-HIDDEN // omite o custNum do objeto Json Filho.
    DATA-RELATION orderOdLine FOR tt-order, tt-orderline
        RELATION-FIELDS(tt-order.orderNum, tt-orderline.orderNum)
            NESTED
                FOREIGN-KEY-HIDDEN.
                
                
