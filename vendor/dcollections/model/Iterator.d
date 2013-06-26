/*********************************************************
   Copyright: (C) 2008-2010 by Steven Schveighoffer.
              All rights reserved

   License: Boost Software License version 1.0

   Permission is hereby granted, free of charge, to any person or organization
   obtaining a copy of the software and accompanying documentation covered by
   this license (the "Software") to use, reproduce, display, distribute,
   execute, and transmit the Software, and to prepare derivative works of the
   Software, and to permit third-parties to whom the Software is furnished to
   do so, all subject to the following:

   The copyright notices in the Software and this entire statement, including
   the above license grant, this restriction and the following disclaimer, must
   be included in all copies of the Software, in whole or in part, and all
   derivative works of the Software, unless such copies or derivative works are
   solely in the form of machine-executable object code generated by a source
   language processor.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
   SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
   FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
   ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
   DEALINGS IN THE SOFTWARE.

**********************************************************/
module dcollections.model.Iterator;

/**
 * Returned from length() when length isn't supported
 */
enum size_t NO_LENGTH_SUPPORT = ~0;

/**
 * Basic iterator.  Allows iterating over all the elements of an object.
 */
interface Iterator(V)
{
    /**
     * Useful for type deduction
     */
    alias V Elem;

    /**
     * If supported, returns the number of elements that will be iterated.
     *
     * If not supported, returns NO_LENGTH_SUPPORT.
     */
    @property size_t length() const;

    /**
     * foreach operator.
     */
    int opApply(scope int delegate(ref V v) dg);
}

/**
 * Iterator with keys.  This allows one to view the key of the element as well
 * as the value while iterating.
 */
interface KeyedIterator(K, V) : Iterator!(V)
{
    alias Iterator!(V).opApply opApply;

    /**
     * Useful for type deduction
     */
    alias K Key;

    /**
     * iterate over both keys and values
     */
    int opApply(scope int delegate(ref K k, ref V v) dg);
}

/**
 * A purge iterator is used to purge values from a collection.  This works by
 * telling the iterator that you want it to remove the value last iterated.
 */
interface Purgeable(V)
{
    /**
     * iterate over the values of the iterator, telling it which values to
     * remove.  To remove a value, set doPurge to true before exiting the
     * loop.
     *
     * Make sure you specify ref for the doPurge parameter:
     *
     * -----
     * foreach(ref doPurge, v; &purgeable.purge){
     * ...
     * -----
     */
    int purge(scope int delegate(ref bool doPurge, ref V v) dg);
}

/**
 * A purge iterator for keyed containers.
 */
interface KeyPurgeable(K, V) : Purgeable!(V)
{
    /**
     * iterate over the key/value pairs of the iterator, telling it which ones
     * to remove.
     *
     * Make sure you specify ref for the doPurge parameter:
     *
     * -----
     * foreach(ref doPurge, k, v; &purgeable.keypurge){
     * ...
     * -----
     *
     * TODO: note this should have the name purge, but because of asonine
     * lookup rules, it makes it difficult to specify this version over the
     * base version.  Once this is fixed, it's highly likely that this goes
     * back to the name purge.
     *
     * See bugzilla #2498
     */
    int keypurge(scope int delegate(ref bool doPurge, ref K k, ref V v) dg);
}
