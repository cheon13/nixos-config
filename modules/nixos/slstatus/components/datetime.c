/* See LICENSE file for copyright and license details. */
#include <stdio.h>
#include <time.h>
#include <locale.h>

#include "../slstatus.h"
#include "../util.h"

const char *
datetime(const char *fmt)
{
	setlocale(LC_ALL, "");
	time_t t;

	t = time(NULL);
	if (!strftime(buf, sizeof(buf), fmt, localtime(&t))) {
		warn("strftime: Result string exceeds buffer size");
		return NULL;
	}

	return buf;
}
