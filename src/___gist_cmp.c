static int
gist_cmp(H3Index  * a, H3Index * b)
{
	int			aRes;
	int			bRes;

	uint64_t	cellMask = (1 << 45) - 1;	/* rightmost 45 bits*/
	uint64_t	aCell;
	uint64_t	bCell;
	uint64_t	mask;

    /* identity */
    if (*a == *b)
	{
		return 1;
	}

    /* no shared basecell */
    if (H3_GET_BASE_CELL(*a) != H3_GET_BASE_CELL(*b))
	{
		return 0;
	}

	aRes = H3_GET_RESOLUTION(*a);
	bRes = H3_GET_RESOLUTION(*b);
	aCell = *a & cellMask;
	bCell = *b & cellMask;

	/* a contains b */
	if (*a == H3_ROOT_INDEX || (aCell^bCell) >> (45 - 3 * aRes) == 0)
	{
		return 1;
	}

	/* a contained by b */
	if (*b == H3_ROOT_INDEX || (aCell^bCell) >> (45 - 3 * bRes) == 0)
	{
		return -1;
	}

	/* no overlap */
	return 0;
}



static H3Index
common_ancestor(H3Index a, H3Index b)
{
	int			aRes;
	int			bRes;
	int			maxRes; 
	uint64_t	cellMask = 35184372088831;	/* rightmost 45 bits*/
	uint64_t	abCell;

	if (a == b)
	{
		return a;
	}

    /* not shared basecell */
    if (H3_GET_BASE_CELL(a) != H3_GET_BASE_CELL(b))
	{
		return H3_ROOT_INDEX;
	}

	abCell = a & b & cellMask;
	/* shared basecell, no more */
	if(abCell == 0)
	{
		return h3GetBaseCell(a);
	} 

	aRes = H3_GET_RESOLUTION(a);
	bRes = H3_GET_RESOLUTION(b);
	maxRes = (aRes < bRes) ? aRes : bRes;
	for (int i = maxRes; i > 0; i--)
	{
		if(abCell >> (i * 3) == 0)
		{
			mask = (1 << (i * 3)) - 1;
			return H3_SET_RESOLUTION(a | mask, i);
		}
	}

	return H3_ROOT_INDEX;
}
