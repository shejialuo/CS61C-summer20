#include "list.h"

/* Add a node to the end of the linked list. Assume head_ptr is non-null. */
void append_node (node** head_ptr, int new_data) {
	/* First lets allocate memory for the new node and initialize its attributes */
	node* ptr = malloc(sizeof(node));
  ptr->next = NULL;
  ptr->val = new_data;

	/* If the list is empty, set the new node to be the head and return */
	if (*head_ptr == NULL) {
		*head_ptr = ptr;
		return;
	}
	node* curr = *head_ptr;
	while (curr->next != NULL) {
		curr = curr->next;
	}
	/* Insert node at the end of the list */
	ptr->next = curr->next;
  curr->next = ptr;
}

/* Reverse a linked list in place (in other words, without creating a new list).
   Assume that head_ptr is non-null. */
void reverse_list (node** head_ptr) {
	node* prev = NULL;
	node* next = *head_ptr;
	while (next != NULL) {
		/* INSERT CODE HERE */
    node* temp = next->next;
    next->next = prev;
    prev = next;
    next = temp;
	}
	/* Set the new head to be what originally was the last node in the list */
	*head_ptr = prev;/* INSERT CODE HERE */
}



