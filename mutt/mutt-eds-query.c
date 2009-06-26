/* mutt-eds-query.c
 * Sertaç Ö. Yıldız <sertacyildizATgmailDOTcom>
 *
 * compilation (requires evolution-data-server development libraries):
 * gcc `pkg-config --cflags --libs libebook-1.2` -o mutt-eds-query mutt-eds-query.c
 */

#include <libebook/e-book.h>
#include <libebook/e-contact.h>
#include <libebook/e-book-query.h>

#define PROGRAM_NAME    "mutt-eds-query"
#define VERSION         "0.1"

static void
print_mutt_line (const gchar *email, const gchar *name,
                 const gchar *nick, const gchar *notes)
{
    printf ("%s\t%s\t%-10s %s\n",
            email ? email : "",
            name  ?  name : "",
            nick  ?  nick : "",
            notes ?  notes: "");
}

static void
process_results (gpointer data, gpointer user_data)
{
        EContact *contact;
        const gchar *fullname, *nickname, *notes;
        GList *emails, *e;

        g_return_if_fail (E_IS_CONTACT(data));
        contact = E_CONTACT (data);

        fullname = e_contact_get_const (contact, E_CONTACT_FULL_NAME);
        nickname = e_contact_get_const (contact, E_CONTACT_NICKNAME);
        notes = e_contact_get_const (contact, E_CONTACT_NOTE);
        emails = e_contact_get (contact, E_CONTACT_EMAIL);

        for (e = emails; e; e = e->next)
            print_mutt_line ((const char *) e->data, fullname,
                                nickname, notes);

       g_list_foreach (emails, (GFunc) g_free, NULL);
       g_list_free (emails);
}

static void
usage (const gchar *me)
{
        fprintf (stderr, "%s (v" VERSION ") : simple e-d-s wrapper for mutt\n", me);
        fprintf (stderr, "Usage: %s <query>\n\n", me);
}

int
main (int argc, char *argv[])
{
        EBook *book;
        EBookQuery *query;
        GList *contacts;

        g_type_init();

        if ( argc > 1 && g_strstr_len (argv[1], 3, "-h")) {
            usage (PROGRAM_NAME);
            exit (1);
        }

        if (argc == 1)
            query = e_book_query_any_field_contains ("");
        else
            query = e_book_query_any_field_contains (argv[1]);

        if (query == NULL) {
            fprintf (stderr, "Couldn't create query.\n");
            exit (2);
        }

        book = e_book_new_system_addressbook (NULL);
        if (!e_book_open (book, TRUE, NULL)) {
            fprintf (stderr, "Couldn't load system addressbook.\n");
            exit (2);
        }

        if (!e_book_get_contacts (book, query, &contacts, NULL)) {
            fprintf (stderr, "Couldn't get query results.\n");
            exit (2);
        }

        e_book_query_unref (query);
        g_object_unref (book);

        if (contacts == NULL) {
            printf ("No matches.\n");
            return (-1);
        } else {
            printf ("Matches for '%s'...\n", argv[1]);
            g_list_foreach (contacts, (GFunc) process_results, NULL);
        }

        return 0;
}
