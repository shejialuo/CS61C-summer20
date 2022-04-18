#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    /* your code here */
    if(head == NULL) return 0;
    node* hare = head ;
    node* tortoise = head;
    while(hare) {
      if(hare->next == NULL)
        return 0;
      hare = hare->next;
      hare = hare->next;
      tortoise = tortoise->next;
      if(hare == tortoise) {
        return 1;
      }
    }
    return 0;
}
