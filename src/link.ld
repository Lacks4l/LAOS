OUTPUT_FORMAT("binary")

SECTIONS
{
	.image 0x7C00 :
	{
		*(.text)
	}
}
