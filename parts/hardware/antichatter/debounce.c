/*
 * debounce — filtre anti-chatter pour interception-tools.
 *
 * Lit des struct input_event bruts sur stdin, les réécrit sur stdout.
 * Un appui (value 1) qui survient moins de N ms après la dernière
 * relâche VUE de la même touche est un rebond de contact : il est jeté,
 * ainsi que sa relâche associée et ses éventuels autorepeats.
 *
 * Le délai se mesure sur le flux brut (dernière relâche vue, pas
 * dernière transmise) : un train de rebonds long ne peut donc pas
 * "repasser sous le seuil" et laisser fuir un doublon.
 *
 * Usage : debounce [seuil_ms]   (défaut : 30)
 *
 * Validé contre la capture réelle du 2026-07-06 (evidence/) :
 * la rafale de 5 paires appui/relâche en 139 ms redevient 1 seule paire.
 */
#include <linux/input.h>
#include <stdio.h>
#include <stdlib.h>

static double ev_time(const struct input_event *e)
{
    return e->time.tv_sec + e->time.tv_usec / 1e6;
}

int main(int argc, char *argv[])
{
    double threshold = (argc > 1 ? atof(argv[1]) : 30.0) / 1000.0;
    static double last_release[KEY_MAX + 1];
    static unsigned char suppressed[KEY_MAX + 1];
    struct input_event ev;

    /* indispensable : sans ça les frappes moisissent dans le buffer stdio */
    setbuf(stdin, NULL);
    setbuf(stdout, NULL);

    while (fread(&ev, sizeof(ev), 1, stdin) == 1) {
        if (ev.type == EV_KEY && ev.code <= KEY_MAX) {
            if (ev.value == 1) {                          /* appui */
                if (last_release[ev.code] > 0 &&
                    ev_time(&ev) - last_release[ev.code] < threshold) {
                    suppressed[ev.code] = 1;
                    continue;                             /* rebond : jeté */
                }
                suppressed[ev.code] = 0;
            } else if (ev.value == 0) {                   /* relâche */
                last_release[ev.code] = ev_time(&ev);
                if (suppressed[ev.code]) {
                    suppressed[ev.code] = 0;
                    continue;                             /* relâche du rebond : jetée */
                }
            } else if (ev.value == 2 && suppressed[ev.code]) {
                continue;                                 /* autorepeat d'un rebond : jeté */
            }
        }
        if (fwrite(&ev, sizeof(ev), 1, stdout) != 1)
            return 1;
    }
    return 0;
}
