
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc a0 cf 10 80       	mov    $0x8010cfa0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 50 2e 10 80       	mov    $0x80102e50,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb d4 cf 10 80       	mov    $0x8010cfd4,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	68 20 79 10 80       	push   $0x80107920
80100051:	68 a0 cf 10 80       	push   $0x8010cfa0
80100056:	e8 85 48 00 00       	call   801048e0 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 ec 16 11 80 9c 	movl   $0x8011169c,0x801116ec
80100062:	16 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 f0 16 11 80 9c 	movl   $0x8011169c,0x801116f0
8010006c:	16 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba 9c 16 11 80       	mov    $0x8011169c,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 9c 16 11 80 	movl   $0x8011169c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 79 10 80       	push   $0x80107927
80100097:	50                   	push   %eax
80100098:	e8 13 47 00 00       	call   801047b0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 f0 16 11 80       	mov    0x801116f0,%eax

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b0:	89 1d f0 16 11 80    	mov    %ebx,0x801116f0

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d 9c 16 11 80       	cmp    $0x8011169c,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000df:	68 a0 cf 10 80       	push   $0x8010cfa0
801000e4:	e8 57 49 00 00       	call   80104a40 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d f0 16 11 80    	mov    0x801116f0,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 9c 16 11 80    	cmp    $0x8011169c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 9c 16 11 80    	cmp    $0x8011169c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d ec 16 11 80    	mov    0x801116ec,%ebx
80100126:	81 fb 9c 16 11 80    	cmp    $0x8011169c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 9c 16 11 80    	cmp    $0x8011169c,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 a0 cf 10 80       	push   $0x8010cfa0
80100162:	e8 89 49 00 00       	call   80104af0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 7e 46 00 00       	call   801047f0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 5d 1f 00 00       	call   801020e0 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 2e 79 10 80       	push   $0x8010792e
80100198:	e8 d3 01 00 00       	call   80100370 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 dd 46 00 00       	call   80104890 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 17 1f 00 00       	jmp    801020e0 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 3f 79 10 80       	push   $0x8010793f
801001d1:	e8 9a 01 00 00       	call   80100370 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 9c 46 00 00       	call   80104890 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 4c 46 00 00       	call   80104850 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 a0 cf 10 80 	movl   $0x8010cfa0,(%esp)
8010020b:	e8 30 48 00 00       	call   80104a40 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 f0 16 11 80       	mov    0x801116f0,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 9c 16 11 80 	movl   $0x8011169c,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100241:	a1 f0 16 11 80       	mov    0x801116f0,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d f0 16 11 80    	mov    %ebx,0x801116f0
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 a0 cf 10 80 	movl   $0x8010cfa0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
8010025c:	e9 8f 48 00 00       	jmp    80104af0 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 46 79 10 80       	push   $0x80107946
80100269:	e8 02 01 00 00       	call   80100370 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 bb 14 00 00       	call   80101740 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 af 47 00 00       	call   80104a40 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 80 19 11 80       	mov    0x80111980,%eax
801002a6:	3b 05 84 19 11 80    	cmp    0x80111984,%eax
801002ac:	74 24                	je     801002d2 <consoleread+0x62>
801002ae:	eb 58                	jmp    80100308 <consoleread+0x98>
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b0:	83 ec 08             	sub    $0x8,%esp
801002b3:	68 20 b5 10 80       	push   $0x8010b520
801002b8:	68 80 19 11 80       	push   $0x80111980
801002bd:	e8 9e 40 00 00       	call   80104360 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c2:	a1 80 19 11 80       	mov    0x80111980,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 84 19 11 80    	cmp    0x80111984,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(myproc()->killed){
801002d2:	e8 19 35 00 00       	call   801037f0 <myproc>
801002d7:	8b 40 24             	mov    0x24(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 b5 10 80       	push   $0x8010b520
801002e6:	e8 05 48 00 00       	call   80104af0 <release>
        ilock(ip);
801002eb:	89 3c 24             	mov    %edi,(%esp)
801002ee:	e8 6d 13 00 00       	call   80101660 <ilock>
        return -1;
801002f3:	83 c4 10             	add    $0x10,%esp
801002f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002fe:	5b                   	pop    %ebx
801002ff:	5e                   	pop    %esi
80100300:	5f                   	pop    %edi
80100301:	5d                   	pop    %ebp
80100302:	c3                   	ret    
80100303:	90                   	nop
80100304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100308:	8d 50 01             	lea    0x1(%eax),%edx
8010030b:	89 15 80 19 11 80    	mov    %edx,0x80111980
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 00 19 11 80 	movsbl -0x7feee700(%edx),%edx
    if(c == C('D')){  // EOF
8010031d:	83 fa 04             	cmp    $0x4,%edx
80100320:	74 39                	je     8010035b <consoleread+0xeb>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100322:	83 c6 01             	add    $0x1,%esi
    --n;
80100325:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100328:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
8010032b:	88 56 ff             	mov    %dl,-0x1(%esi)
    --n;
    if(c == '\n')
8010032e:	74 35                	je     80100365 <consoleread+0xf5>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100330:	85 db                	test   %ebx,%ebx
80100332:	0f 85 69 ff ff ff    	jne    801002a1 <consoleread+0x31>
80100338:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
8010033b:	83 ec 0c             	sub    $0xc,%esp
8010033e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100341:	68 20 b5 10 80       	push   $0x8010b520
80100346:	e8 a5 47 00 00       	call   80104af0 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 0d 13 00 00       	call   80101660 <ilock>

  return target - n;
80100353:	83 c4 10             	add    $0x10,%esp
80100356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100359:	eb a0                	jmp    801002fb <consoleread+0x8b>
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
8010035b:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010035e:	76 05                	jbe    80100365 <consoleread+0xf5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100360:	a3 80 19 11 80       	mov    %eax,0x80111980
80100365:	8b 45 10             	mov    0x10(%ebp),%eax
80100368:	29 d8                	sub    %ebx,%eax
8010036a:	eb cf                	jmp    8010033b <consoleread+0xcb>
8010036c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100370 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	56                   	push   %esi
80100374:	53                   	push   %ebx
80100375:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100378:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100379:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
80100380:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100383:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100386:	8d 75 f8             	lea    -0x8(%ebp),%esi
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100389:	e8 52 23 00 00       	call   801026e0 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 4d 79 10 80       	push   $0x8010794d
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 63 84 10 80 	movl   $0x80108463,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 43 45 00 00       	call   80104900 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 61 79 10 80       	push   $0x80107961
801003cd:	e8 8e 02 00 00       	call   80100660 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003d2:	83 c4 10             	add    $0x10,%esp
801003d5:	39 f3                	cmp    %esi,%ebx
801003d7:	75 e7                	jne    801003c0 <panic+0x50>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
801003e0:	00 00 00 
801003e3:	eb fe                	jmp    801003e3 <panic+0x73>
801003e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801003f0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003f0:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801003f6:	85 d2                	test   %edx,%edx
801003f8:	74 06                	je     80100400 <consputc+0x10>
801003fa:	fa                   	cli    
801003fb:	eb fe                	jmp    801003fb <consputc+0xb>
801003fd:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 0c             	sub    $0xc,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 b8 00 00 00    	je     801004ce <consputc+0xde>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 21 5f 00 00       	call   80106340 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	c1 e0 08             	shl    $0x8,%eax
8010043f:	89 c1                	mov    %eax,%ecx
80100441:	b8 0f 00 00 00       	mov    $0xf,%eax
80100446:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100447:	89 f2                	mov    %esi,%edx
80100449:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
8010044a:	0f b6 c0             	movzbl %al,%eax
8010044d:	09 c8                	or     %ecx,%eax

  if(c == '\n')
8010044f:	83 fb 0a             	cmp    $0xa,%ebx
80100452:	0f 84 0b 01 00 00    	je     80100563 <consputc+0x173>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100458:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045e:	0f 84 e6 00 00 00    	je     8010054a <consputc+0x15a>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100464:	0f b6 d3             	movzbl %bl,%edx
80100467:	8d 78 01             	lea    0x1(%eax),%edi
8010046a:	80 ce 07             	or     $0x7,%dh
8010046d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100474:	80 

  if(pos < 0 || pos > 25*80)
80100475:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
8010047b:	0f 8f bc 00 00 00    	jg     8010053d <consputc+0x14d>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
80100481:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100487:	7f 6f                	jg     801004f8 <consputc+0x108>
80100489:	89 f8                	mov    %edi,%eax
8010048b:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
80100492:	89 fb                	mov    %edi,%ebx
80100494:	c1 e8 08             	shr    $0x8,%eax
80100497:	89 c6                	mov    %eax,%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100499:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010049e:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a3:	89 fa                	mov    %edi,%edx
801004a5:	ee                   	out    %al,(%dx)
801004a6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004ab:	89 f0                	mov    %esi,%eax
801004ad:	ee                   	out    %al,(%dx)
801004ae:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b3:	89 fa                	mov    %edi,%edx
801004b5:	ee                   	out    %al,(%dx)
801004b6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004bb:	89 d8                	mov    %ebx,%eax
801004bd:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004be:	b8 20 07 00 00       	mov    $0x720,%eax
801004c3:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c9:	5b                   	pop    %ebx
801004ca:	5e                   	pop    %esi
801004cb:	5f                   	pop    %edi
801004cc:	5d                   	pop    %ebp
801004cd:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004ce:	83 ec 0c             	sub    $0xc,%esp
801004d1:	6a 08                	push   $0x8
801004d3:	e8 68 5e 00 00       	call   80106340 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 5c 5e 00 00       	call   80106340 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 50 5e 00 00       	call   80106340 <uartputc>
801004f0:	83 c4 10             	add    $0x10,%esp
801004f3:	e9 2a ff ff ff       	jmp    80100422 <consputc+0x32>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f8:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004fb:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004fe:	68 60 0e 00 00       	push   $0xe60
80100503:	68 a0 80 0b 80       	push   $0x800b80a0
80100508:	68 00 80 0b 80       	push   $0x800b8000
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010050d:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100514:	e8 d7 46 00 00       	call   80104bf0 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 12 46 00 00       	call   80104b40 <memset>
8010052e:	89 f1                	mov    %esi,%ecx
80100530:	83 c4 10             	add    $0x10,%esp
80100533:	be 07 00 00 00       	mov    $0x7,%esi
80100538:	e9 5c ff ff ff       	jmp    80100499 <consputc+0xa9>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010053d:	83 ec 0c             	sub    $0xc,%esp
80100540:	68 65 79 10 80       	push   $0x80107965
80100545:	e8 26 fe ff ff       	call   80100370 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
8010054a:	85 c0                	test   %eax,%eax
8010054c:	8d 78 ff             	lea    -0x1(%eax),%edi
8010054f:	0f 85 20 ff ff ff    	jne    80100475 <consputc+0x85>
80100555:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
8010055a:	31 db                	xor    %ebx,%ebx
8010055c:	31 f6                	xor    %esi,%esi
8010055e:	e9 36 ff ff ff       	jmp    80100499 <consputc+0xa9>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
80100563:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100568:	f7 ea                	imul   %edx
8010056a:	89 d0                	mov    %edx,%eax
8010056c:	c1 e8 05             	shr    $0x5,%eax
8010056f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100572:	c1 e0 04             	shl    $0x4,%eax
80100575:	8d 78 50             	lea    0x50(%eax),%edi
80100578:	e9 f8 fe ff ff       	jmp    80100475 <consputc+0x85>
8010057d:	8d 76 00             	lea    0x0(%esi),%esi

80100580 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d6                	mov    %edx,%esi
80100588:	83 ec 2c             	sub    $0x2c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100590:	74 0c                	je     8010059e <printint+0x1e>
80100592:	89 c7                	mov    %eax,%edi
80100594:	c1 ef 1f             	shr    $0x1f,%edi
80100597:	85 c0                	test   %eax,%eax
80100599:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010059c:	78 51                	js     801005ef <printint+0x6f>
    x = -xx;
  else
    x = xx;

  i = 0;
8010059e:	31 ff                	xor    %edi,%edi
801005a0:	8d 5d d7             	lea    -0x29(%ebp),%ebx
801005a3:	eb 05                	jmp    801005aa <printint+0x2a>
801005a5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
801005a8:	89 cf                	mov    %ecx,%edi
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 4f 01             	lea    0x1(%edi),%ecx
801005af:	f7 f6                	div    %esi
801005b1:	0f b6 92 90 79 10 80 	movzbl -0x7fef8670(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005ba:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>

  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
801005cb:	8d 4f 02             	lea    0x2(%edi),%ecx
801005ce:	8d 74 0d d7          	lea    -0x29(%ebp,%ecx,1),%esi
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  while(--i >= 0)
    consputc(buf[i]);
801005d8:	0f be 06             	movsbl (%esi),%eax
801005db:	83 ee 01             	sub    $0x1,%esi
801005de:	e8 0d fe ff ff       	call   801003f0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005e3:	39 de                	cmp    %ebx,%esi
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
    consputc(buf[i]);
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
801005ef:	f7 d8                	neg    %eax
801005f1:	eb ab                	jmp    8010059e <printint+0x1e>
801005f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100600 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100609:	ff 75 08             	pushl  0x8(%ebp)
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010060c:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060f:	e8 2c 11 00 00       	call   80101740 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 20 44 00 00       	call   80104a40 <acquire>
80100620:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100623:	83 c4 10             	add    $0x10,%esp
80100626:	85 f6                	test   %esi,%esi
80100628:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062b:	7e 12                	jle    8010063f <consolewrite+0x3f>
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 b5 fd ff ff       	call   801003f0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010063b:	39 df                	cmp    %ebx,%edi
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 a4 44 00 00       	call   80104af0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 0b 10 00 00       	call   80101660 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100670:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100673:	0f 85 47 01 00 00    	jne    801007c0 <cprintf+0x160>
    acquire(&cons.lock);

  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c1                	mov    %eax,%ecx
80100680:	0f 84 4f 01 00 00    	je     801007d5 <cprintf+0x175>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
80100689:	31 db                	xor    %ebx,%ebx
8010068b:	8d 75 0c             	lea    0xc(%ebp),%esi
8010068e:	89 cf                	mov    %ecx,%edi
80100690:	85 c0                	test   %eax,%eax
80100692:	75 55                	jne    801006e9 <cprintf+0x89>
80100694:	eb 68                	jmp    801006fe <cprintf+0x9e>
80100696:	8d 76 00             	lea    0x0(%esi),%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
801006a0:	83 c3 01             	add    $0x1,%ebx
801006a3:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
801006a7:	85 d2                	test   %edx,%edx
801006a9:	74 53                	je     801006fe <cprintf+0x9e>
      break;
    switch(c){
801006ab:	83 fa 70             	cmp    $0x70,%edx
801006ae:	74 7a                	je     8010072a <cprintf+0xca>
801006b0:	7f 6e                	jg     80100720 <cprintf+0xc0>
801006b2:	83 fa 25             	cmp    $0x25,%edx
801006b5:	0f 84 ad 00 00 00    	je     80100768 <cprintf+0x108>
801006bb:	83 fa 64             	cmp    $0x64,%edx
801006be:	0f 85 84 00 00 00    	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
801006c4:	8d 46 04             	lea    0x4(%esi),%eax
801006c7:	b9 01 00 00 00       	mov    $0x1,%ecx
801006cc:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d4:	8b 06                	mov    (%esi),%eax
801006d6:	e8 a5 fe ff ff       	call   80100580 <printint>
801006db:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006de:	83 c3 01             	add    $0x1,%ebx
801006e1:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e5:	85 c0                	test   %eax,%eax
801006e7:	74 15                	je     801006fe <cprintf+0x9e>
    if(c != '%'){
801006e9:	83 f8 25             	cmp    $0x25,%eax
801006ec:	74 b2                	je     801006a0 <cprintf+0x40>
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
801006ee:	e8 fd fc ff ff       	call   801003f0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f3:	83 c3 01             	add    $0x1,%ebx
801006f6:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006fa:	85 c0                	test   %eax,%eax
801006fc:	75 eb                	jne    801006e9 <cprintf+0x89>
      consputc(c);
      break;
    }
  }

  if(locking)
801006fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100701:	85 c0                	test   %eax,%eax
80100703:	74 10                	je     80100715 <cprintf+0xb5>
    release(&cons.lock);
80100705:	83 ec 0c             	sub    $0xc,%esp
80100708:	68 20 b5 10 80       	push   $0x8010b520
8010070d:	e8 de 43 00 00       	call   80104af0 <release>
80100712:	83 c4 10             	add    $0x10,%esp
}
80100715:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100718:	5b                   	pop    %ebx
80100719:	5e                   	pop    %esi
8010071a:	5f                   	pop    %edi
8010071b:	5d                   	pop    %ebp
8010071c:	c3                   	ret    
8010071d:	8d 76 00             	lea    0x0(%esi),%esi
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100720:	83 fa 73             	cmp    $0x73,%edx
80100723:	74 5b                	je     80100780 <cprintf+0x120>
80100725:	83 fa 78             	cmp    $0x78,%edx
80100728:	75 1e                	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010072a:	8d 46 04             	lea    0x4(%esi),%eax
8010072d:	31 c9                	xor    %ecx,%ecx
8010072f:	ba 10 00 00 00       	mov    $0x10,%edx
80100734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100737:	8b 06                	mov    (%esi),%eax
80100739:	e8 42 fe ff ff       	call   80100580 <printint>
8010073e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100741:	eb 9b                	jmp    801006de <cprintf+0x7e>
80100743:	90                   	nop
80100744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100750:	e8 9b fc ff ff       	call   801003f0 <consputc>
      consputc(c);
80100755:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100758:	89 d0                	mov    %edx,%eax
8010075a:	e8 91 fc ff ff       	call   801003f0 <consputc>
      break;
8010075f:	e9 7a ff ff ff       	jmp    801006de <cprintf+0x7e>
80100764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100768:	b8 25 00 00 00       	mov    $0x25,%eax
8010076d:	e8 7e fc ff ff       	call   801003f0 <consputc>
80100772:	e9 7c ff ff ff       	jmp    801006f3 <cprintf+0x93>
80100777:	89 f6                	mov    %esi,%esi
80100779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100780:	8d 46 04             	lea    0x4(%esi),%eax
80100783:	8b 36                	mov    (%esi),%esi
80100785:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100788:	b8 78 79 10 80       	mov    $0x80107978,%eax
8010078d:	85 f6                	test   %esi,%esi
8010078f:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
80100792:	0f be 06             	movsbl (%esi),%eax
80100795:	84 c0                	test   %al,%al
80100797:	74 16                	je     801007af <cprintf+0x14f>
80100799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007a0:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
801007a3:	e8 48 fc ff ff       	call   801003f0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801007a8:	0f be 06             	movsbl (%esi),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
801007af:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801007b2:	e9 27 ff ff ff       	jmp    801006de <cprintf+0x7e>
801007b7:	89 f6                	mov    %esi,%esi
801007b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
801007c0:	83 ec 0c             	sub    $0xc,%esp
801007c3:	68 20 b5 10 80       	push   $0x8010b520
801007c8:	e8 73 42 00 00       	call   80104a40 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 7f 79 10 80       	push   $0x8010797f
801007dd:	e8 8e fb ff ff       	call   80100370 <panic>
801007e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801007f0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f0:	55                   	push   %ebp
801007f1:	89 e5                	mov    %esp,%ebp
801007f3:	57                   	push   %edi
801007f4:	56                   	push   %esi
801007f5:	53                   	push   %ebx
  int c, doprocdump = 0;
801007f6:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f8:	83 ec 18             	sub    $0x18,%esp
801007fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007fe:	68 20 b5 10 80       	push   $0x8010b520
80100803:	e8 38 42 00 00       	call   80104a40 <acquire>
  while((c = getc()) >= 0){
80100808:	83 c4 10             	add    $0x10,%esp
8010080b:	90                   	nop
8010080c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100810:	ff d3                	call   *%ebx
80100812:	85 c0                	test   %eax,%eax
80100814:	89 c7                	mov    %eax,%edi
80100816:	78 48                	js     80100860 <consoleintr+0x70>
    switch(c){
80100818:	83 ff 10             	cmp    $0x10,%edi
8010081b:	0f 84 3f 01 00 00    	je     80100960 <consoleintr+0x170>
80100821:	7e 5d                	jle    80100880 <consoleintr+0x90>
80100823:	83 ff 15             	cmp    $0x15,%edi
80100826:	0f 84 dc 00 00 00    	je     80100908 <consoleintr+0x118>
8010082c:	83 ff 7f             	cmp    $0x7f,%edi
8010082f:	75 54                	jne    80100885 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100831:	a1 88 19 11 80       	mov    0x80111988,%eax
80100836:	3b 05 84 19 11 80    	cmp    0x80111984,%eax
8010083c:	74 d2                	je     80100810 <consoleintr+0x20>
        input.e--;
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 88 19 11 80       	mov    %eax,0x80111988
        consputc(BACKSPACE);
80100846:	b8 00 01 00 00       	mov    $0x100,%eax
8010084b:	e8 a0 fb ff ff       	call   801003f0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100850:	ff d3                	call   *%ebx
80100852:	85 c0                	test   %eax,%eax
80100854:	89 c7                	mov    %eax,%edi
80100856:	79 c0                	jns    80100818 <consoleintr+0x28>
80100858:	90                   	nop
80100859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100860:	83 ec 0c             	sub    $0xc,%esp
80100863:	68 20 b5 10 80       	push   $0x8010b520
80100868:	e8 83 42 00 00       	call   80104af0 <release>
  if(doprocdump) {
8010086d:	83 c4 10             	add    $0x10,%esp
80100870:	85 f6                	test   %esi,%esi
80100872:	0f 85 f8 00 00 00    	jne    80100970 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100878:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010087b:	5b                   	pop    %ebx
8010087c:	5e                   	pop    %esi
8010087d:	5f                   	pop    %edi
8010087e:	5d                   	pop    %ebp
8010087f:	c3                   	ret    
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100880:	83 ff 08             	cmp    $0x8,%edi
80100883:	74 ac                	je     80100831 <consoleintr+0x41>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100885:	85 ff                	test   %edi,%edi
80100887:	74 87                	je     80100810 <consoleintr+0x20>
80100889:	a1 88 19 11 80       	mov    0x80111988,%eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	2b 15 80 19 11 80    	sub    0x80111980,%edx
80100896:	83 fa 7f             	cmp    $0x7f,%edx
80100899:	0f 87 71 ff ff ff    	ja     80100810 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010089f:	8d 50 01             	lea    0x1(%eax),%edx
801008a2:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008a5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008a8:	89 15 88 19 11 80    	mov    %edx,0x80111988
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008ae:	0f 84 c8 00 00 00    	je     8010097c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b4:	89 f9                	mov    %edi,%ecx
801008b6:	88 88 00 19 11 80    	mov    %cl,-0x7feee700(%eax)
        consputc(c);
801008bc:	89 f8                	mov    %edi,%eax
801008be:	e8 2d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 ff 0a             	cmp    $0xa,%edi
801008c6:	0f 84 c1 00 00 00    	je     8010098d <consoleintr+0x19d>
801008cc:	83 ff 04             	cmp    $0x4,%edi
801008cf:	0f 84 b8 00 00 00    	je     8010098d <consoleintr+0x19d>
801008d5:	a1 80 19 11 80       	mov    0x80111980,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 88 19 11 80    	cmp    %eax,0x80111988
801008e3:	0f 85 27 ff ff ff    	jne    80100810 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008e9:	83 ec 0c             	sub    $0xc,%esp
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ec:	a3 84 19 11 80       	mov    %eax,0x80111984
          wakeup(&input.r);
801008f1:	68 80 19 11 80       	push   $0x80111980
801008f6:	e8 95 3c 00 00       	call   80104590 <wakeup>
801008fb:	83 c4 10             	add    $0x10,%esp
801008fe:	e9 0d ff ff ff       	jmp    80100810 <consoleintr+0x20>
80100903:	90                   	nop
80100904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100908:	a1 88 19 11 80       	mov    0x80111988,%eax
8010090d:	39 05 84 19 11 80    	cmp    %eax,0x80111984
80100913:	75 2b                	jne    80100940 <consoleintr+0x150>
80100915:	e9 f6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100920:	a3 88 19 11 80       	mov    %eax,0x80111988
        consputc(BACKSPACE);
80100925:	b8 00 01 00 00       	mov    $0x100,%eax
8010092a:	e8 c1 fa ff ff       	call   801003f0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010092f:	a1 88 19 11 80       	mov    0x80111988,%eax
80100934:	3b 05 84 19 11 80    	cmp    0x80111984,%eax
8010093a:	0f 84 d0 fe ff ff    	je     80100810 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100940:	83 e8 01             	sub    $0x1,%eax
80100943:	89 c2                	mov    %eax,%edx
80100945:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100948:	80 ba 00 19 11 80 0a 	cmpb   $0xa,-0x7feee700(%edx)
8010094f:	75 cf                	jne    80100920 <consoleintr+0x130>
80100951:	e9 ba fe ff ff       	jmp    80100810 <consoleintr+0x20>
80100956:	8d 76 00             	lea    0x0(%esi),%esi
80100959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100960:	be 01 00 00 00       	mov    $0x1,%esi
80100965:	e9 a6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010096a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100973:	5b                   	pop    %ebx
80100974:	5e                   	pop    %esi
80100975:	5f                   	pop    %edi
80100976:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100977:	e9 04 3d 00 00       	jmp    80104680 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010097c:	c6 80 00 19 11 80 0a 	movb   $0xa,-0x7feee700(%eax)
        consputc(c);
80100983:	b8 0a 00 00 00       	mov    $0xa,%eax
80100988:	e8 63 fa ff ff       	call   801003f0 <consputc>
8010098d:	a1 88 19 11 80       	mov    0x80111988,%eax
80100992:	e9 52 ff ff ff       	jmp    801008e9 <consoleintr+0xf9>
80100997:	89 f6                	mov    %esi,%esi
80100999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801009a0 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009a6:	68 88 79 10 80       	push   $0x80107988
801009ab:	68 20 b5 10 80       	push   $0x8010b520
801009b0:	e8 2b 3f 00 00       	call   801048e0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009b5:	58                   	pop    %eax
801009b6:	5a                   	pop    %edx
801009b7:	6a 00                	push   $0x0
801009b9:	6a 01                	push   $0x1
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
801009bb:	c7 05 4c 23 11 80 00 	movl   $0x80100600,0x8011234c
801009c2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009c5:	c7 05 48 23 11 80 70 	movl   $0x80100270,0x80112348
801009cc:	02 10 80 
  cons.locking = 1;
801009cf:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009d6:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801009d9:	e8 b2 18 00 00       	call   80102290 <ioapicenable>
}
801009de:	83 c4 10             	add    $0x10,%esp
801009e1:	c9                   	leave  
801009e2:	c3                   	ret    
801009e3:	66 90                	xchg   %ax,%ax
801009e5:	66 90                	xchg   %ax,%ax
801009e7:	66 90                	xchg   %ax,%ax
801009e9:	66 90                	xchg   %ax,%ax
801009eb:	66 90                	xchg   %ax,%ax
801009ed:	66 90                	xchg   %ax,%ax
801009ef:	90                   	nop

801009f0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009f0:	55                   	push   %ebp
801009f1:	89 e5                	mov    %esp,%ebp
801009f3:	57                   	push   %edi
801009f4:	56                   	push   %esi
801009f5:	53                   	push   %ebx
801009f6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009fc:	e8 ef 2d 00 00       	call   801037f0 <myproc>
80100a01:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a07:	e8 34 21 00 00       	call   80102b40 <begin_op>

  if((ip = namei(path)) == 0){
80100a0c:	83 ec 0c             	sub    $0xc,%esp
80100a0f:	ff 75 08             	pushl  0x8(%ebp)
80100a12:	e8 99 14 00 00       	call   80101eb0 <namei>
80100a17:	83 c4 10             	add    $0x10,%esp
80100a1a:	85 c0                	test   %eax,%eax
80100a1c:	0f 84 9c 01 00 00    	je     80100bbe <exec+0x1ce>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a22:	83 ec 0c             	sub    $0xc,%esp
80100a25:	89 c3                	mov    %eax,%ebx
80100a27:	50                   	push   %eax
80100a28:	e8 33 0c 00 00       	call   80101660 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a2d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a33:	6a 34                	push   $0x34
80100a35:	6a 00                	push   $0x0
80100a37:	50                   	push   %eax
80100a38:	53                   	push   %ebx
80100a39:	e8 02 0f 00 00       	call   80101940 <readi>
80100a3e:	83 c4 20             	add    $0x20,%esp
80100a41:	83 f8 34             	cmp    $0x34,%eax
80100a44:	74 22                	je     80100a68 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a46:	83 ec 0c             	sub    $0xc,%esp
80100a49:	53                   	push   %ebx
80100a4a:	e8 a1 0e 00 00       	call   801018f0 <iunlockput>
    end_op();
80100a4f:	e8 5c 21 00 00       	call   80102bb0 <end_op>
80100a54:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a5f:	5b                   	pop    %ebx
80100a60:	5e                   	pop    %esi
80100a61:	5f                   	pop    %edi
80100a62:	5d                   	pop    %ebp
80100a63:	c3                   	ret    
80100a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a68:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a6f:	45 4c 46 
80100a72:	75 d2                	jne    80100a46 <exec+0x56>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a74:	e8 e7 6b 00 00       	call   80107660 <setupkvm>
80100a79:	85 c0                	test   %eax,%eax
80100a7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a81:	74 c3                	je     80100a46 <exec+0x56>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a83:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a8a:	00 
80100a8b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100a91:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a98:	00 00 00 
80100a9b:	0f 84 c5 00 00 00    	je     80100b66 <exec+0x176>
80100aa1:	31 ff                	xor    %edi,%edi
80100aa3:	eb 18                	jmp    80100abd <exec+0xcd>
80100aa5:	8d 76 00             	lea    0x0(%esi),%esi
80100aa8:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100aaf:	83 c7 01             	add    $0x1,%edi
80100ab2:	83 c6 20             	add    $0x20,%esi
80100ab5:	39 f8                	cmp    %edi,%eax
80100ab7:	0f 8e a9 00 00 00    	jle    80100b66 <exec+0x176>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100abd:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100ac3:	6a 20                	push   $0x20
80100ac5:	56                   	push   %esi
80100ac6:	50                   	push   %eax
80100ac7:	53                   	push   %ebx
80100ac8:	e8 73 0e 00 00       	call   80101940 <readi>
80100acd:	83 c4 10             	add    $0x10,%esp
80100ad0:	83 f8 20             	cmp    $0x20,%eax
80100ad3:	75 7b                	jne    80100b50 <exec+0x160>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100ad5:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100adc:	75 ca                	jne    80100aa8 <exec+0xb8>
      continue;
    if(ph.memsz < ph.filesz)
80100ade:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ae4:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100aea:	72 64                	jb     80100b50 <exec+0x160>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100aec:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100af2:	72 5c                	jb     80100b50 <exec+0x160>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100af4:	83 ec 04             	sub    $0x4,%esp
80100af7:	50                   	push   %eax
80100af8:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100afe:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b04:	e8 a7 69 00 00       	call   801074b0 <allocuvm>
80100b09:	83 c4 10             	add    $0x10,%esp
80100b0c:	85 c0                	test   %eax,%eax
80100b0e:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100b14:	74 3a                	je     80100b50 <exec+0x160>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b16:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b1c:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b21:	75 2d                	jne    80100b50 <exec+0x160>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b23:	83 ec 0c             	sub    $0xc,%esp
80100b26:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b2c:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b32:	53                   	push   %ebx
80100b33:	50                   	push   %eax
80100b34:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b3a:	e8 b1 68 00 00       	call   801073f0 <loaduvm>
80100b3f:	83 c4 20             	add    $0x20,%esp
80100b42:	85 c0                	test   %eax,%eax
80100b44:	0f 89 5e ff ff ff    	jns    80100aa8 <exec+0xb8>
80100b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b50:	83 ec 0c             	sub    $0xc,%esp
80100b53:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b59:	e8 82 6a 00 00       	call   801075e0 <freevm>
80100b5e:	83 c4 10             	add    $0x10,%esp
80100b61:	e9 e0 fe ff ff       	jmp    80100a46 <exec+0x56>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b66:	83 ec 0c             	sub    $0xc,%esp
80100b69:	53                   	push   %ebx
80100b6a:	e8 81 0d 00 00       	call   801018f0 <iunlockput>
  end_op();
80100b6f:	e8 3c 20 00 00       	call   80102bb0 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b74:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b7a:	83 c4 0c             	add    $0xc,%esp
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b7d:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b87:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b8d:	52                   	push   %edx
80100b8e:	50                   	push   %eax
80100b8f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b95:	e8 16 69 00 00       	call   801074b0 <allocuvm>
80100b9a:	83 c4 10             	add    $0x10,%esp
80100b9d:	85 c0                	test   %eax,%eax
80100b9f:	89 c6                	mov    %eax,%esi
80100ba1:	75 3a                	jne    80100bdd <exec+0x1ed>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100ba3:	83 ec 0c             	sub    $0xc,%esp
80100ba6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bac:	e8 2f 6a 00 00       	call   801075e0 <freevm>
80100bb1:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100bb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bb9:	e9 9e fe ff ff       	jmp    80100a5c <exec+0x6c>
  struct proc *curproc = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100bbe:	e8 ed 1f 00 00       	call   80102bb0 <end_op>
    cprintf("exec: fail\n");
80100bc3:	83 ec 0c             	sub    $0xc,%esp
80100bc6:	68 a1 79 10 80       	push   $0x801079a1
80100bcb:	e8 90 fa ff ff       	call   80100660 <cprintf>
    return -1;
80100bd0:	83 c4 10             	add    $0x10,%esp
80100bd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bd8:	e9 7f fe ff ff       	jmp    80100a5c <exec+0x6c>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bdd:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100be3:	83 ec 08             	sub    $0x8,%esp
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100be6:	31 ff                	xor    %edi,%edi
80100be8:	89 f3                	mov    %esi,%ebx
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bea:	50                   	push   %eax
80100beb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bf1:	e8 0a 6b 00 00       	call   80107700 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bf9:	83 c4 10             	add    $0x10,%esp
80100bfc:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c02:	8b 00                	mov    (%eax),%eax
80100c04:	85 c0                	test   %eax,%eax
80100c06:	74 79                	je     80100c81 <exec+0x291>
80100c08:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c0e:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c14:	eb 13                	jmp    80100c29 <exec+0x239>
80100c16:	8d 76 00             	lea    0x0(%esi),%esi
80100c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(argc >= MAXARG)
80100c20:	83 ff 20             	cmp    $0x20,%edi
80100c23:	0f 84 7a ff ff ff    	je     80100ba3 <exec+0x1b3>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c29:	83 ec 0c             	sub    $0xc,%esp
80100c2c:	50                   	push   %eax
80100c2d:	e8 4e 41 00 00       	call   80104d80 <strlen>
80100c32:	f7 d0                	not    %eax
80100c34:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c36:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c39:	5a                   	pop    %edx

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c3a:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c3d:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c40:	e8 3b 41 00 00       	call   80104d80 <strlen>
80100c45:	83 c0 01             	add    $0x1,%eax
80100c48:	50                   	push   %eax
80100c49:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c4c:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4f:	53                   	push   %ebx
80100c50:	56                   	push   %esi
80100c51:	e8 1a 6c 00 00       	call   80107870 <copyout>
80100c56:	83 c4 20             	add    $0x20,%esp
80100c59:	85 c0                	test   %eax,%eax
80100c5b:	0f 88 42 ff ff ff    	js     80100ba3 <exec+0x1b3>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c61:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c64:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c6b:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c6e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c74:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c77:	85 c0                	test   %eax,%eax
80100c79:	75 a5                	jne    80100c20 <exec+0x230>
80100c7b:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c81:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c88:	89 d9                	mov    %ebx,%ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c8a:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c91:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100c95:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c9c:	ff ff ff 
  ustack[1] = argc;
80100c9f:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ca5:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100ca7:	83 c0 0c             	add    $0xc,%eax
80100caa:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cac:	50                   	push   %eax
80100cad:	52                   	push   %edx
80100cae:	53                   	push   %ebx
80100caf:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb5:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cbb:	e8 b0 6b 00 00       	call   80107870 <copyout>
80100cc0:	83 c4 10             	add    $0x10,%esp
80100cc3:	85 c0                	test   %eax,%eax
80100cc5:	0f 88 d8 fe ff ff    	js     80100ba3 <exec+0x1b3>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ccb:	8b 45 08             	mov    0x8(%ebp),%eax
80100cce:	0f b6 10             	movzbl (%eax),%edx
80100cd1:	84 d2                	test   %dl,%dl
80100cd3:	74 19                	je     80100cee <exec+0x2fe>
80100cd5:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cd8:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100cdb:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cde:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100ce1:	0f 44 c8             	cmove  %eax,%ecx
80100ce4:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ce7:	84 d2                	test   %dl,%dl
80100ce9:	75 f0                	jne    80100cdb <exec+0x2eb>
80100ceb:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cee:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cf4:	50                   	push   %eax
80100cf5:	6a 10                	push   $0x10
80100cf7:	ff 75 08             	pushl  0x8(%ebp)
80100cfa:	89 f8                	mov    %edi,%eax
80100cfc:	83 c0 6c             	add    $0x6c,%eax
80100cff:	50                   	push   %eax
80100d00:	e8 3b 40 00 00       	call   80104d40 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d05:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100d0b:	89 f8                	mov    %edi,%eax
80100d0d:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->pgdir = pgdir;
  curproc->sz = sz;
80100d10:	89 30                	mov    %esi,(%eax)
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d12:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
80100d15:	89 c1                	mov    %eax,%ecx
80100d17:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d1d:	8b 40 18             	mov    0x18(%eax),%eax
80100d20:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d23:	8b 41 18             	mov    0x18(%ecx),%eax
80100d26:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d29:	89 0c 24             	mov    %ecx,(%esp)
80100d2c:	e8 2f 65 00 00       	call   80107260 <switchuvm>
  freevm(oldpgdir);
80100d31:	89 3c 24             	mov    %edi,(%esp)
80100d34:	e8 a7 68 00 00       	call   801075e0 <freevm>
  return 0;
80100d39:	83 c4 10             	add    $0x10,%esp
80100d3c:	31 c0                	xor    %eax,%eax
80100d3e:	e9 19 fd ff ff       	jmp    80100a5c <exec+0x6c>
80100d43:	66 90                	xchg   %ax,%ax
80100d45:	66 90                	xchg   %ax,%ax
80100d47:	66 90                	xchg   %ax,%ax
80100d49:	66 90                	xchg   %ax,%ax
80100d4b:	66 90                	xchg   %ax,%ax
80100d4d:	66 90                	xchg   %ax,%ax
80100d4f:	90                   	nop

80100d50 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d56:	68 ad 79 10 80       	push   $0x801079ad
80100d5b:	68 a0 19 11 80       	push   $0x801119a0
80100d60:	e8 7b 3b 00 00       	call   801048e0 <initlock>
}
80100d65:	83 c4 10             	add    $0x10,%esp
80100d68:	c9                   	leave  
80100d69:	c3                   	ret    
80100d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d70 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d74:	bb d4 19 11 80       	mov    $0x801119d4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d79:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d7c:	68 a0 19 11 80       	push   $0x801119a0
80100d81:	e8 ba 3c 00 00       	call   80104a40 <acquire>
80100d86:	83 c4 10             	add    $0x10,%esp
80100d89:	eb 10                	jmp    80100d9b <filealloc+0x2b>
80100d8b:	90                   	nop
80100d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d90:	83 c3 18             	add    $0x18,%ebx
80100d93:	81 fb 34 23 11 80    	cmp    $0x80112334,%ebx
80100d99:	74 25                	je     80100dc0 <filealloc+0x50>
    if(f->ref == 0){
80100d9b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d9e:	85 c0                	test   %eax,%eax
80100da0:	75 ee                	jne    80100d90 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100da2:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100da5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dac:	68 a0 19 11 80       	push   $0x801119a0
80100db1:	e8 3a 3d 00 00       	call   80104af0 <release>
      return f;
80100db6:	89 d8                	mov    %ebx,%eax
80100db8:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dbe:	c9                   	leave  
80100dbf:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100dc0:	83 ec 0c             	sub    $0xc,%esp
80100dc3:	68 a0 19 11 80       	push   $0x801119a0
80100dc8:	e8 23 3d 00 00       	call   80104af0 <release>
  return 0;
80100dcd:	83 c4 10             	add    $0x10,%esp
80100dd0:	31 c0                	xor    %eax,%eax
}
80100dd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dd5:	c9                   	leave  
80100dd6:	c3                   	ret    
80100dd7:	89 f6                	mov    %esi,%esi
80100dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100de0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	53                   	push   %ebx
80100de4:	83 ec 10             	sub    $0x10,%esp
80100de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dea:	68 a0 19 11 80       	push   $0x801119a0
80100def:	e8 4c 3c 00 00       	call   80104a40 <acquire>
  if(f->ref < 1)
80100df4:	8b 43 04             	mov    0x4(%ebx),%eax
80100df7:	83 c4 10             	add    $0x10,%esp
80100dfa:	85 c0                	test   %eax,%eax
80100dfc:	7e 1a                	jle    80100e18 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100dfe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e01:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80100e04:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e07:	68 a0 19 11 80       	push   $0x801119a0
80100e0c:	e8 df 3c 00 00       	call   80104af0 <release>
  return f;
}
80100e11:	89 d8                	mov    %ebx,%eax
80100e13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e16:	c9                   	leave  
80100e17:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e18:	83 ec 0c             	sub    $0xc,%esp
80100e1b:	68 b4 79 10 80       	push   $0x801079b4
80100e20:	e8 4b f5 ff ff       	call   80100370 <panic>
80100e25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e30 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	57                   	push   %edi
80100e34:	56                   	push   %esi
80100e35:	53                   	push   %ebx
80100e36:	83 ec 28             	sub    $0x28,%esp
80100e39:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e3c:	68 a0 19 11 80       	push   $0x801119a0
80100e41:	e8 fa 3b 00 00       	call   80104a40 <acquire>
  if(f->ref < 1)
80100e46:	8b 47 04             	mov    0x4(%edi),%eax
80100e49:	83 c4 10             	add    $0x10,%esp
80100e4c:	85 c0                	test   %eax,%eax
80100e4e:	0f 8e 9b 00 00 00    	jle    80100eef <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e54:	83 e8 01             	sub    $0x1,%eax
80100e57:	85 c0                	test   %eax,%eax
80100e59:	89 47 04             	mov    %eax,0x4(%edi)
80100e5c:	74 1a                	je     80100e78 <fileclose+0x48>
    release(&ftable.lock);
80100e5e:	c7 45 08 a0 19 11 80 	movl   $0x801119a0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e68:	5b                   	pop    %ebx
80100e69:	5e                   	pop    %esi
80100e6a:	5f                   	pop    %edi
80100e6b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e6c:	e9 7f 3c 00 00       	jmp    80104af0 <release>
80100e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80100e78:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e7c:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e7e:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e81:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80100e84:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e8a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e8d:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e90:	68 a0 19 11 80       	push   $0x801119a0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e95:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e98:	e8 53 3c 00 00       	call   80104af0 <release>

  if(ff.type == FD_PIPE)
80100e9d:	83 c4 10             	add    $0x10,%esp
80100ea0:	83 fb 01             	cmp    $0x1,%ebx
80100ea3:	74 13                	je     80100eb8 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100ea5:	83 fb 02             	cmp    $0x2,%ebx
80100ea8:	74 26                	je     80100ed0 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100eaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ead:	5b                   	pop    %ebx
80100eae:	5e                   	pop    %esi
80100eaf:	5f                   	pop    %edi
80100eb0:	5d                   	pop    %ebp
80100eb1:	c3                   	ret    
80100eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100eb8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ebc:	83 ec 08             	sub    $0x8,%esp
80100ebf:	53                   	push   %ebx
80100ec0:	56                   	push   %esi
80100ec1:	e8 1a 24 00 00       	call   801032e0 <pipeclose>
80100ec6:	83 c4 10             	add    $0x10,%esp
80100ec9:	eb df                	jmp    80100eaa <fileclose+0x7a>
80100ecb:	90                   	nop
80100ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100ed0:	e8 6b 1c 00 00       	call   80102b40 <begin_op>
    iput(ff.ip);
80100ed5:	83 ec 0c             	sub    $0xc,%esp
80100ed8:	ff 75 e0             	pushl  -0x20(%ebp)
80100edb:	e8 b0 08 00 00       	call   80101790 <iput>
    end_op();
80100ee0:	83 c4 10             	add    $0x10,%esp
  }
}
80100ee3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ee6:	5b                   	pop    %ebx
80100ee7:	5e                   	pop    %esi
80100ee8:	5f                   	pop    %edi
80100ee9:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100eea:	e9 c1 1c 00 00       	jmp    80102bb0 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100eef:	83 ec 0c             	sub    $0xc,%esp
80100ef2:	68 bc 79 10 80       	push   $0x801079bc
80100ef7:	e8 74 f4 ff ff       	call   80100370 <panic>
80100efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f00 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	53                   	push   %ebx
80100f04:	83 ec 04             	sub    $0x4,%esp
80100f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f0a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f0d:	75 31                	jne    80100f40 <filestat+0x40>
    ilock(f->ip);
80100f0f:	83 ec 0c             	sub    $0xc,%esp
80100f12:	ff 73 10             	pushl  0x10(%ebx)
80100f15:	e8 46 07 00 00       	call   80101660 <ilock>
    stati(f->ip, st);
80100f1a:	58                   	pop    %eax
80100f1b:	5a                   	pop    %edx
80100f1c:	ff 75 0c             	pushl  0xc(%ebp)
80100f1f:	ff 73 10             	pushl  0x10(%ebx)
80100f22:	e8 e9 09 00 00       	call   80101910 <stati>
    iunlock(f->ip);
80100f27:	59                   	pop    %ecx
80100f28:	ff 73 10             	pushl  0x10(%ebx)
80100f2b:	e8 10 08 00 00       	call   80101740 <iunlock>
    return 0;
80100f30:	83 c4 10             	add    $0x10,%esp
80100f33:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f38:	c9                   	leave  
80100f39:	c3                   	ret    
80100f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f50 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	57                   	push   %edi
80100f54:	56                   	push   %esi
80100f55:	53                   	push   %ebx
80100f56:	83 ec 0c             	sub    $0xc,%esp
80100f59:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f5f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f62:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f66:	74 60                	je     80100fc8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f68:	8b 03                	mov    (%ebx),%eax
80100f6a:	83 f8 01             	cmp    $0x1,%eax
80100f6d:	74 41                	je     80100fb0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f6f:	83 f8 02             	cmp    $0x2,%eax
80100f72:	75 5b                	jne    80100fcf <fileread+0x7f>
    ilock(f->ip);
80100f74:	83 ec 0c             	sub    $0xc,%esp
80100f77:	ff 73 10             	pushl  0x10(%ebx)
80100f7a:	e8 e1 06 00 00       	call   80101660 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f7f:	57                   	push   %edi
80100f80:	ff 73 14             	pushl  0x14(%ebx)
80100f83:	56                   	push   %esi
80100f84:	ff 73 10             	pushl  0x10(%ebx)
80100f87:	e8 b4 09 00 00       	call   80101940 <readi>
80100f8c:	83 c4 20             	add    $0x20,%esp
80100f8f:	85 c0                	test   %eax,%eax
80100f91:	89 c6                	mov    %eax,%esi
80100f93:	7e 03                	jle    80100f98 <fileread+0x48>
      f->off += r;
80100f95:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f98:	83 ec 0c             	sub    $0xc,%esp
80100f9b:	ff 73 10             	pushl  0x10(%ebx)
80100f9e:	e8 9d 07 00 00       	call   80101740 <iunlock>
    return r;
80100fa3:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fa6:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fab:	5b                   	pop    %ebx
80100fac:	5e                   	pop    %esi
80100fad:	5f                   	pop    %edi
80100fae:	5d                   	pop    %ebp
80100faf:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fb0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fb3:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	5b                   	pop    %ebx
80100fba:	5e                   	pop    %esi
80100fbb:	5f                   	pop    %edi
80100fbc:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fbd:	e9 be 24 00 00       	jmp    80103480 <piperead>
80100fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fcd:	eb d9                	jmp    80100fa8 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fcf:	83 ec 0c             	sub    $0xc,%esp
80100fd2:	68 c6 79 10 80       	push   $0x801079c6
80100fd7:	e8 94 f3 ff ff       	call   80100370 <panic>
80100fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fe0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	57                   	push   %edi
80100fe4:	56                   	push   %esi
80100fe5:	53                   	push   %ebx
80100fe6:	83 ec 1c             	sub    $0x1c,%esp
80100fe9:	8b 75 08             	mov    0x8(%ebp),%esi
80100fec:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fef:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100ff6:	8b 45 10             	mov    0x10(%ebp),%eax
80100ff9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100ffc:	0f 84 aa 00 00 00    	je     801010ac <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101002:	8b 06                	mov    (%esi),%eax
80101004:	83 f8 01             	cmp    $0x1,%eax
80101007:	0f 84 c2 00 00 00    	je     801010cf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010100d:	83 f8 02             	cmp    $0x2,%eax
80101010:	0f 85 d8 00 00 00    	jne    801010ee <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101016:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101019:	31 ff                	xor    %edi,%edi
8010101b:	85 c0                	test   %eax,%eax
8010101d:	7f 34                	jg     80101053 <filewrite+0x73>
8010101f:	e9 9c 00 00 00       	jmp    801010c0 <filewrite+0xe0>
80101024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101028:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010102b:	83 ec 0c             	sub    $0xc,%esp
8010102e:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101031:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101034:	e8 07 07 00 00       	call   80101740 <iunlock>
      end_op();
80101039:	e8 72 1b 00 00       	call   80102bb0 <end_op>
8010103e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101041:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101044:	39 d8                	cmp    %ebx,%eax
80101046:	0f 85 95 00 00 00    	jne    801010e1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
8010104c:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010104e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101051:	7e 6d                	jle    801010c0 <filewrite+0xe0>
      int n1 = n - i;
80101053:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101056:	b8 00 06 00 00       	mov    $0x600,%eax
8010105b:	29 fb                	sub    %edi,%ebx
8010105d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101063:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101066:	e8 d5 1a 00 00       	call   80102b40 <begin_op>
      ilock(f->ip);
8010106b:	83 ec 0c             	sub    $0xc,%esp
8010106e:	ff 76 10             	pushl  0x10(%esi)
80101071:	e8 ea 05 00 00       	call   80101660 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101076:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101079:	53                   	push   %ebx
8010107a:	ff 76 14             	pushl  0x14(%esi)
8010107d:	01 f8                	add    %edi,%eax
8010107f:	50                   	push   %eax
80101080:	ff 76 10             	pushl  0x10(%esi)
80101083:	e8 b8 09 00 00       	call   80101a40 <writei>
80101088:	83 c4 20             	add    $0x20,%esp
8010108b:	85 c0                	test   %eax,%eax
8010108d:	7f 99                	jg     80101028 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
8010108f:	83 ec 0c             	sub    $0xc,%esp
80101092:	ff 76 10             	pushl  0x10(%esi)
80101095:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101098:	e8 a3 06 00 00       	call   80101740 <iunlock>
      end_op();
8010109d:	e8 0e 1b 00 00       	call   80102bb0 <end_op>

      if(r < 0)
801010a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010a5:	83 c4 10             	add    $0x10,%esp
801010a8:	85 c0                	test   %eax,%eax
801010aa:	74 98                	je     80101044 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801010b4:	5b                   	pop    %ebx
801010b5:	5e                   	pop    %esi
801010b6:	5f                   	pop    %edi
801010b7:	5d                   	pop    %ebp
801010b8:	c3                   	ret    
801010b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010c0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801010c3:	75 e7                	jne    801010ac <filewrite+0xcc>
  }
  panic("filewrite");
}
801010c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c8:	89 f8                	mov    %edi,%eax
801010ca:	5b                   	pop    %ebx
801010cb:	5e                   	pop    %esi
801010cc:	5f                   	pop    %edi
801010cd:	5d                   	pop    %ebp
801010ce:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010cf:	8b 46 0c             	mov    0xc(%esi),%eax
801010d2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	5b                   	pop    %ebx
801010d9:	5e                   	pop    %esi
801010da:	5f                   	pop    %edi
801010db:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010dc:	e9 9f 22 00 00       	jmp    80103380 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010e1:	83 ec 0c             	sub    $0xc,%esp
801010e4:	68 cf 79 10 80       	push   $0x801079cf
801010e9:	e8 82 f2 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010ee:	83 ec 0c             	sub    $0xc,%esp
801010f1:	68 d5 79 10 80       	push   $0x801079d5
801010f6:	e8 75 f2 ff ff       	call   80100370 <panic>
801010fb:	66 90                	xchg   %ax,%ax
801010fd:	66 90                	xchg   %ax,%ax
801010ff:	90                   	nop

80101100 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	56                   	push   %esi
80101104:	53                   	push   %ebx
80101105:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101107:	c1 ea 0c             	shr    $0xc,%edx
8010110a:	03 15 b8 23 11 80    	add    0x801123b8,%edx
80101110:	83 ec 08             	sub    $0x8,%esp
80101113:	52                   	push   %edx
80101114:	50                   	push   %eax
80101115:	e8 b6 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010111a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010111c:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101122:	ba 01 00 00 00       	mov    $0x1,%edx
80101127:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010112a:	c1 fb 03             	sar    $0x3,%ebx
8010112d:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101130:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101132:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101137:	85 d1                	test   %edx,%ecx
80101139:	74 27                	je     80101162 <bfree+0x62>
8010113b:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010113d:	f7 d2                	not    %edx
8010113f:	89 c8                	mov    %ecx,%eax
  log_write(bp);
80101141:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101144:	21 d0                	and    %edx,%eax
80101146:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010114a:	56                   	push   %esi
8010114b:	e8 d0 1b 00 00       	call   80102d20 <log_write>
  brelse(bp);
80101150:	89 34 24             	mov    %esi,(%esp)
80101153:	e8 88 f0 ff ff       	call   801001e0 <brelse>
}
80101158:	83 c4 10             	add    $0x10,%esp
8010115b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010115e:	5b                   	pop    %ebx
8010115f:	5e                   	pop    %esi
80101160:	5d                   	pop    %ebp
80101161:	c3                   	ret    

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101162:	83 ec 0c             	sub    $0xc,%esp
80101165:	68 df 79 10 80       	push   $0x801079df
8010116a:	e8 01 f2 ff ff       	call   80100370 <panic>
8010116f:	90                   	nop

80101170 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101170:	55                   	push   %ebp
80101171:	89 e5                	mov    %esp,%ebp
80101173:	57                   	push   %edi
80101174:	56                   	push   %esi
80101175:	53                   	push   %ebx
80101176:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101179:	8b 0d a0 23 11 80    	mov    0x801123a0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010117f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101182:	85 c9                	test   %ecx,%ecx
80101184:	0f 84 85 00 00 00    	je     8010120f <balloc+0x9f>
8010118a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101191:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101194:	83 ec 08             	sub    $0x8,%esp
80101197:	89 f0                	mov    %esi,%eax
80101199:	c1 f8 0c             	sar    $0xc,%eax
8010119c:	03 05 b8 23 11 80    	add    0x801123b8,%eax
801011a2:	50                   	push   %eax
801011a3:	ff 75 d8             	pushl  -0x28(%ebp)
801011a6:	e8 25 ef ff ff       	call   801000d0 <bread>
801011ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011ae:	a1 a0 23 11 80       	mov    0x801123a0,%eax
801011b3:	83 c4 10             	add    $0x10,%esp
801011b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011b9:	31 c0                	xor    %eax,%eax
801011bb:	eb 2d                	jmp    801011ea <balloc+0x7a>
801011bd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011c0:	89 c1                	mov    %eax,%ecx
801011c2:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011c7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
801011ca:	83 e1 07             	and    $0x7,%ecx
801011cd:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011cf:	89 c1                	mov    %eax,%ecx
801011d1:	c1 f9 03             	sar    $0x3,%ecx
801011d4:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
801011d9:	85 d7                	test   %edx,%edi
801011db:	74 43                	je     80101220 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011dd:	83 c0 01             	add    $0x1,%eax
801011e0:	83 c6 01             	add    $0x1,%esi
801011e3:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011e8:	74 05                	je     801011ef <balloc+0x7f>
801011ea:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801011ed:	72 d1                	jb     801011c0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801011ef:	83 ec 0c             	sub    $0xc,%esp
801011f2:	ff 75 e4             	pushl  -0x1c(%ebp)
801011f5:	e8 e6 ef ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011fa:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101201:	83 c4 10             	add    $0x10,%esp
80101204:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101207:	39 05 a0 23 11 80    	cmp    %eax,0x801123a0
8010120d:	77 82                	ja     80101191 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010120f:	83 ec 0c             	sub    $0xc,%esp
80101212:	68 f2 79 10 80       	push   $0x801079f2
80101217:	e8 54 f1 ff ff       	call   80100370 <panic>
8010121c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101220:	09 fa                	or     %edi,%edx
80101222:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101225:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101228:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010122c:	57                   	push   %edi
8010122d:	e8 ee 1a 00 00       	call   80102d20 <log_write>
        brelse(bp);
80101232:	89 3c 24             	mov    %edi,(%esp)
80101235:	e8 a6 ef ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
8010123a:	58                   	pop    %eax
8010123b:	5a                   	pop    %edx
8010123c:	56                   	push   %esi
8010123d:	ff 75 d8             	pushl  -0x28(%ebp)
80101240:	e8 8b ee ff ff       	call   801000d0 <bread>
80101245:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101247:	8d 40 5c             	lea    0x5c(%eax),%eax
8010124a:	83 c4 0c             	add    $0xc,%esp
8010124d:	68 00 02 00 00       	push   $0x200
80101252:	6a 00                	push   $0x0
80101254:	50                   	push   %eax
80101255:	e8 e6 38 00 00       	call   80104b40 <memset>
  log_write(bp);
8010125a:	89 1c 24             	mov    %ebx,(%esp)
8010125d:	e8 be 1a 00 00       	call   80102d20 <log_write>
  brelse(bp);
80101262:	89 1c 24             	mov    %ebx,(%esp)
80101265:	e8 76 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
8010126a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010126d:	89 f0                	mov    %esi,%eax
8010126f:	5b                   	pop    %ebx
80101270:	5e                   	pop    %esi
80101271:	5f                   	pop    %edi
80101272:	5d                   	pop    %ebp
80101273:	c3                   	ret    
80101274:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010127a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101280 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101280:	55                   	push   %ebp
80101281:	89 e5                	mov    %esp,%ebp
80101283:	57                   	push   %edi
80101284:	56                   	push   %esi
80101285:	53                   	push   %ebx
80101286:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101288:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010128a:	bb f4 23 11 80       	mov    $0x801123f4,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010128f:	83 ec 28             	sub    $0x28,%esp
80101292:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101295:	68 c0 23 11 80       	push   $0x801123c0
8010129a:	e8 a1 37 00 00       	call   80104a40 <acquire>
8010129f:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012a5:	eb 1b                	jmp    801012c2 <iget+0x42>
801012a7:	89 f6                	mov    %esi,%esi
801012a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012b0:	85 f6                	test   %esi,%esi
801012b2:	74 44                	je     801012f8 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012b4:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012ba:	81 fb 14 40 11 80    	cmp    $0x80114014,%ebx
801012c0:	74 4e                	je     80101310 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012c2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012c5:	85 c9                	test   %ecx,%ecx
801012c7:	7e e7                	jle    801012b0 <iget+0x30>
801012c9:	39 3b                	cmp    %edi,(%ebx)
801012cb:	75 e3                	jne    801012b0 <iget+0x30>
801012cd:	39 53 04             	cmp    %edx,0x4(%ebx)
801012d0:	75 de                	jne    801012b0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
801012d2:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
801012d5:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
801012d8:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
801012da:	68 c0 23 11 80       	push   $0x801123c0

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
801012df:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012e2:	e8 09 38 00 00       	call   80104af0 <release>
      return ip;
801012e7:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
801012ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ed:	89 f0                	mov    %esi,%eax
801012ef:	5b                   	pop    %ebx
801012f0:	5e                   	pop    %esi
801012f1:	5f                   	pop    %edi
801012f2:	5d                   	pop    %ebp
801012f3:	c3                   	ret    
801012f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012f8:	85 c9                	test   %ecx,%ecx
801012fa:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012fd:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101303:	81 fb 14 40 11 80    	cmp    $0x80114014,%ebx
80101309:	75 b7                	jne    801012c2 <iget+0x42>
8010130b:	90                   	nop
8010130c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101310:	85 f6                	test   %esi,%esi
80101312:	74 2d                	je     80101341 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101314:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101317:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101319:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010131c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101323:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010132a:	68 c0 23 11 80       	push   $0x801123c0
8010132f:	e8 bc 37 00 00       	call   80104af0 <release>

  return ip;
80101334:	83 c4 10             	add    $0x10,%esp
}
80101337:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133a:	89 f0                	mov    %esi,%eax
8010133c:	5b                   	pop    %ebx
8010133d:	5e                   	pop    %esi
8010133e:	5f                   	pop    %edi
8010133f:	5d                   	pop    %ebp
80101340:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
80101341:	83 ec 0c             	sub    $0xc,%esp
80101344:	68 08 7a 10 80       	push   $0x80107a08
80101349:	e8 22 f0 ff ff       	call   80100370 <panic>
8010134e:	66 90                	xchg   %ax,%ax

80101350 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	56                   	push   %esi
80101355:	53                   	push   %ebx
80101356:	89 c6                	mov    %eax,%esi
80101358:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010135b:	83 fa 0b             	cmp    $0xb,%edx
8010135e:	77 18                	ja     80101378 <bmap+0x28>
80101360:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
80101363:	8b 43 5c             	mov    0x5c(%ebx),%eax
80101366:	85 c0                	test   %eax,%eax
80101368:	74 76                	je     801013e0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010136a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010136d:	5b                   	pop    %ebx
8010136e:	5e                   	pop    %esi
8010136f:	5f                   	pop    %edi
80101370:	5d                   	pop    %ebp
80101371:	c3                   	ret    
80101372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101378:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
8010137b:	83 fb 7f             	cmp    $0x7f,%ebx
8010137e:	0f 87 83 00 00 00    	ja     80101407 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101384:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010138a:	85 c0                	test   %eax,%eax
8010138c:	74 6a                	je     801013f8 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010138e:	83 ec 08             	sub    $0x8,%esp
80101391:	50                   	push   %eax
80101392:	ff 36                	pushl  (%esi)
80101394:	e8 37 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101399:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010139d:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801013a0:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801013a2:	8b 1a                	mov    (%edx),%ebx
801013a4:	85 db                	test   %ebx,%ebx
801013a6:	75 1d                	jne    801013c5 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
801013a8:	8b 06                	mov    (%esi),%eax
801013aa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013ad:	e8 be fd ff ff       	call   80101170 <balloc>
801013b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013b5:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
801013b8:	89 c3                	mov    %eax,%ebx
801013ba:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801013bc:	57                   	push   %edi
801013bd:	e8 5e 19 00 00       	call   80102d20 <log_write>
801013c2:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
801013c5:	83 ec 0c             	sub    $0xc,%esp
801013c8:	57                   	push   %edi
801013c9:	e8 12 ee ff ff       	call   801001e0 <brelse>
801013ce:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801013d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801013d4:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
801013d6:	5b                   	pop    %ebx
801013d7:	5e                   	pop    %esi
801013d8:	5f                   	pop    %edi
801013d9:	5d                   	pop    %ebp
801013da:	c3                   	ret    
801013db:	90                   	nop
801013dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
801013e0:	8b 06                	mov    (%esi),%eax
801013e2:	e8 89 fd ff ff       	call   80101170 <balloc>
801013e7:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801013ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013ed:	5b                   	pop    %ebx
801013ee:	5e                   	pop    %esi
801013ef:	5f                   	pop    %edi
801013f0:	5d                   	pop    %ebp
801013f1:	c3                   	ret    
801013f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013f8:	8b 06                	mov    (%esi),%eax
801013fa:	e8 71 fd ff ff       	call   80101170 <balloc>
801013ff:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101405:	eb 87                	jmp    8010138e <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101407:	83 ec 0c             	sub    $0xc,%esp
8010140a:	68 18 7a 10 80       	push   $0x80107a18
8010140f:	e8 5c ef ff ff       	call   80100370 <panic>
80101414:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010141a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101420 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101420:	55                   	push   %ebp
80101421:	89 e5                	mov    %esp,%ebp
80101423:	56                   	push   %esi
80101424:	53                   	push   %ebx
80101425:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
80101428:	83 ec 08             	sub    $0x8,%esp
8010142b:	6a 01                	push   $0x1
8010142d:	ff 75 08             	pushl  0x8(%ebp)
80101430:	e8 9b ec ff ff       	call   801000d0 <bread>
80101435:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101437:	8d 40 5c             	lea    0x5c(%eax),%eax
8010143a:	83 c4 0c             	add    $0xc,%esp
8010143d:	6a 1c                	push   $0x1c
8010143f:	50                   	push   %eax
80101440:	56                   	push   %esi
80101441:	e8 aa 37 00 00       	call   80104bf0 <memmove>
  brelse(bp);
80101446:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101449:	83 c4 10             	add    $0x10,%esp
}
8010144c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010144f:	5b                   	pop    %ebx
80101450:	5e                   	pop    %esi
80101451:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
80101452:	e9 89 ed ff ff       	jmp    801001e0 <brelse>
80101457:	89 f6                	mov    %esi,%esi
80101459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101460 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101460:	55                   	push   %ebp
80101461:	89 e5                	mov    %esp,%ebp
80101463:	53                   	push   %ebx
80101464:	bb 00 24 11 80       	mov    $0x80112400,%ebx
80101469:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010146c:	68 2b 7a 10 80       	push   $0x80107a2b
80101471:	68 c0 23 11 80       	push   $0x801123c0
80101476:	e8 65 34 00 00       	call   801048e0 <initlock>
8010147b:	83 c4 10             	add    $0x10,%esp
8010147e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101480:	83 ec 08             	sub    $0x8,%esp
80101483:	68 32 7a 10 80       	push   $0x80107a32
80101488:	53                   	push   %ebx
80101489:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010148f:	e8 1c 33 00 00       	call   801047b0 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101494:	83 c4 10             	add    $0x10,%esp
80101497:	81 fb 20 40 11 80    	cmp    $0x80114020,%ebx
8010149d:	75 e1                	jne    80101480 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
8010149f:	83 ec 08             	sub    $0x8,%esp
801014a2:	68 a0 23 11 80       	push   $0x801123a0
801014a7:	ff 75 08             	pushl  0x8(%ebp)
801014aa:	e8 71 ff ff ff       	call   80101420 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014af:	ff 35 b8 23 11 80    	pushl  0x801123b8
801014b5:	ff 35 b4 23 11 80    	pushl  0x801123b4
801014bb:	ff 35 b0 23 11 80    	pushl  0x801123b0
801014c1:	ff 35 ac 23 11 80    	pushl  0x801123ac
801014c7:	ff 35 a8 23 11 80    	pushl  0x801123a8
801014cd:	ff 35 a4 23 11 80    	pushl  0x801123a4
801014d3:	ff 35 a0 23 11 80    	pushl  0x801123a0
801014d9:	68 98 7a 10 80       	push   $0x80107a98
801014de:	e8 7d f1 ff ff       	call   80100660 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801014e3:	83 c4 30             	add    $0x30,%esp
801014e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014e9:	c9                   	leave  
801014ea:	c3                   	ret    
801014eb:	90                   	nop
801014ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801014f0 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
801014f0:	55                   	push   %ebp
801014f1:	89 e5                	mov    %esp,%ebp
801014f3:	57                   	push   %edi
801014f4:	56                   	push   %esi
801014f5:	53                   	push   %ebx
801014f6:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801014f9:	83 3d a8 23 11 80 01 	cmpl   $0x1,0x801123a8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101500:	8b 45 0c             	mov    0xc(%ebp),%eax
80101503:	8b 75 08             	mov    0x8(%ebp),%esi
80101506:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101509:	0f 86 91 00 00 00    	jbe    801015a0 <ialloc+0xb0>
8010150f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101514:	eb 21                	jmp    80101537 <ialloc+0x47>
80101516:	8d 76 00             	lea    0x0(%esi),%esi
80101519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101520:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101523:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101526:	57                   	push   %edi
80101527:	e8 b4 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010152c:	83 c4 10             	add    $0x10,%esp
8010152f:	39 1d a8 23 11 80    	cmp    %ebx,0x801123a8
80101535:	76 69                	jbe    801015a0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101537:	89 d8                	mov    %ebx,%eax
80101539:	83 ec 08             	sub    $0x8,%esp
8010153c:	c1 e8 03             	shr    $0x3,%eax
8010153f:	03 05 b4 23 11 80    	add    0x801123b4,%eax
80101545:	50                   	push   %eax
80101546:	56                   	push   %esi
80101547:	e8 84 eb ff ff       	call   801000d0 <bread>
8010154c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010154e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101550:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
80101553:	83 e0 07             	and    $0x7,%eax
80101556:	c1 e0 06             	shl    $0x6,%eax
80101559:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010155d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101561:	75 bd                	jne    80101520 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101563:	83 ec 04             	sub    $0x4,%esp
80101566:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101569:	6a 40                	push   $0x40
8010156b:	6a 00                	push   $0x0
8010156d:	51                   	push   %ecx
8010156e:	e8 cd 35 00 00       	call   80104b40 <memset>
      dip->type = type;
80101573:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101577:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010157a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010157d:	89 3c 24             	mov    %edi,(%esp)
80101580:	e8 9b 17 00 00       	call   80102d20 <log_write>
      brelse(bp);
80101585:	89 3c 24             	mov    %edi,(%esp)
80101588:	e8 53 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010158d:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101590:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101593:	89 da                	mov    %ebx,%edx
80101595:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101597:	5b                   	pop    %ebx
80101598:	5e                   	pop    %esi
80101599:	5f                   	pop    %edi
8010159a:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
8010159b:	e9 e0 fc ff ff       	jmp    80101280 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801015a0:	83 ec 0c             	sub    $0xc,%esp
801015a3:	68 38 7a 10 80       	push   $0x80107a38
801015a8:	e8 c3 ed ff ff       	call   80100370 <panic>
801015ad:	8d 76 00             	lea    0x0(%esi),%esi

801015b0 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
801015b0:	55                   	push   %ebp
801015b1:	89 e5                	mov    %esp,%ebp
801015b3:	56                   	push   %esi
801015b4:	53                   	push   %ebx
801015b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015b8:	83 ec 08             	sub    $0x8,%esp
801015bb:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015be:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015c1:	c1 e8 03             	shr    $0x3,%eax
801015c4:	03 05 b4 23 11 80    	add    0x801123b4,%eax
801015ca:	50                   	push   %eax
801015cb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015ce:	e8 fd ea ff ff       	call   801000d0 <bread>
801015d3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015d5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015d8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015dc:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015df:	83 e0 07             	and    $0x7,%eax
801015e2:	c1 e0 06             	shl    $0x6,%eax
801015e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801015e9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801015ec:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015f0:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
801015f3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801015f7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801015fb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801015ff:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101603:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101607:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010160a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160d:	6a 34                	push   $0x34
8010160f:	53                   	push   %ebx
80101610:	50                   	push   %eax
80101611:	e8 da 35 00 00       	call   80104bf0 <memmove>
  log_write(bp);
80101616:	89 34 24             	mov    %esi,(%esp)
80101619:	e8 02 17 00 00       	call   80102d20 <log_write>
  brelse(bp);
8010161e:	89 75 08             	mov    %esi,0x8(%ebp)
80101621:	83 c4 10             	add    $0x10,%esp
}
80101624:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101627:	5b                   	pop    %ebx
80101628:	5e                   	pop    %esi
80101629:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
8010162a:	e9 b1 eb ff ff       	jmp    801001e0 <brelse>
8010162f:	90                   	nop

80101630 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	53                   	push   %ebx
80101634:	83 ec 10             	sub    $0x10,%esp
80101637:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010163a:	68 c0 23 11 80       	push   $0x801123c0
8010163f:	e8 fc 33 00 00       	call   80104a40 <acquire>
  ip->ref++;
80101644:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101648:	c7 04 24 c0 23 11 80 	movl   $0x801123c0,(%esp)
8010164f:	e8 9c 34 00 00       	call   80104af0 <release>
  return ip;
}
80101654:	89 d8                	mov    %ebx,%eax
80101656:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101659:	c9                   	leave  
8010165a:	c3                   	ret    
8010165b:	90                   	nop
8010165c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101660 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	56                   	push   %esi
80101664:	53                   	push   %ebx
80101665:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101668:	85 db                	test   %ebx,%ebx
8010166a:	0f 84 b7 00 00 00    	je     80101727 <ilock+0xc7>
80101670:	8b 53 08             	mov    0x8(%ebx),%edx
80101673:	85 d2                	test   %edx,%edx
80101675:	0f 8e ac 00 00 00    	jle    80101727 <ilock+0xc7>
    panic("ilock");

  acquiresleep(&ip->lock);
8010167b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010167e:	83 ec 0c             	sub    $0xc,%esp
80101681:	50                   	push   %eax
80101682:	e8 69 31 00 00       	call   801047f0 <acquiresleep>

  if(ip->valid == 0){
80101687:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010168a:	83 c4 10             	add    $0x10,%esp
8010168d:	85 c0                	test   %eax,%eax
8010168f:	74 0f                	je     801016a0 <ilock+0x40>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
80101691:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101694:	5b                   	pop    %ebx
80101695:	5e                   	pop    %esi
80101696:	5d                   	pop    %ebp
80101697:	c3                   	ret    
80101698:	90                   	nop
80101699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016a0:	8b 43 04             	mov    0x4(%ebx),%eax
801016a3:	83 ec 08             	sub    $0x8,%esp
801016a6:	c1 e8 03             	shr    $0x3,%eax
801016a9:	03 05 b4 23 11 80    	add    0x801123b4,%eax
801016af:	50                   	push   %eax
801016b0:	ff 33                	pushl  (%ebx)
801016b2:	e8 19 ea ff ff       	call   801000d0 <bread>
801016b7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016b9:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016bc:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016bf:	83 e0 07             	and    $0x7,%eax
801016c2:	c1 e0 06             	shl    $0x6,%eax
801016c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016c9:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016cc:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
801016cf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016d3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016d7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016db:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016df:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801016e3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801016e7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801016eb:	8b 50 fc             	mov    -0x4(%eax),%edx
801016ee:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016f1:	6a 34                	push   $0x34
801016f3:	50                   	push   %eax
801016f4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801016f7:	50                   	push   %eax
801016f8:	e8 f3 34 00 00       	call   80104bf0 <memmove>
    brelse(bp);
801016fd:	89 34 24             	mov    %esi,(%esp)
80101700:	e8 db ea ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101705:	83 c4 10             	add    $0x10,%esp
80101708:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010170d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101714:	0f 85 77 ff ff ff    	jne    80101691 <ilock+0x31>
      panic("ilock: no type");
8010171a:	83 ec 0c             	sub    $0xc,%esp
8010171d:	68 50 7a 10 80       	push   $0x80107a50
80101722:	e8 49 ec ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101727:	83 ec 0c             	sub    $0xc,%esp
8010172a:	68 4a 7a 10 80       	push   $0x80107a4a
8010172f:	e8 3c ec ff ff       	call   80100370 <panic>
80101734:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010173a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101740 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101740:	55                   	push   %ebp
80101741:	89 e5                	mov    %esp,%ebp
80101743:	56                   	push   %esi
80101744:	53                   	push   %ebx
80101745:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101748:	85 db                	test   %ebx,%ebx
8010174a:	74 28                	je     80101774 <iunlock+0x34>
8010174c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010174f:	83 ec 0c             	sub    $0xc,%esp
80101752:	56                   	push   %esi
80101753:	e8 38 31 00 00       	call   80104890 <holdingsleep>
80101758:	83 c4 10             	add    $0x10,%esp
8010175b:	85 c0                	test   %eax,%eax
8010175d:	74 15                	je     80101774 <iunlock+0x34>
8010175f:	8b 43 08             	mov    0x8(%ebx),%eax
80101762:	85 c0                	test   %eax,%eax
80101764:	7e 0e                	jle    80101774 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
80101766:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101769:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010176c:	5b                   	pop    %ebx
8010176d:	5e                   	pop    %esi
8010176e:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
8010176f:	e9 dc 30 00 00       	jmp    80104850 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101774:	83 ec 0c             	sub    $0xc,%esp
80101777:	68 5f 7a 10 80       	push   $0x80107a5f
8010177c:	e8 ef eb ff ff       	call   80100370 <panic>
80101781:	eb 0d                	jmp    80101790 <iput>
80101783:	90                   	nop
80101784:	90                   	nop
80101785:	90                   	nop
80101786:	90                   	nop
80101787:	90                   	nop
80101788:	90                   	nop
80101789:	90                   	nop
8010178a:	90                   	nop
8010178b:	90                   	nop
8010178c:	90                   	nop
8010178d:	90                   	nop
8010178e:	90                   	nop
8010178f:	90                   	nop

80101790 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	57                   	push   %edi
80101794:	56                   	push   %esi
80101795:	53                   	push   %ebx
80101796:	83 ec 28             	sub    $0x28,%esp
80101799:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
8010179c:	8d 7e 0c             	lea    0xc(%esi),%edi
8010179f:	57                   	push   %edi
801017a0:	e8 4b 30 00 00       	call   801047f0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017a5:	8b 56 4c             	mov    0x4c(%esi),%edx
801017a8:	83 c4 10             	add    $0x10,%esp
801017ab:	85 d2                	test   %edx,%edx
801017ad:	74 07                	je     801017b6 <iput+0x26>
801017af:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017b4:	74 32                	je     801017e8 <iput+0x58>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
801017b6:	83 ec 0c             	sub    $0xc,%esp
801017b9:	57                   	push   %edi
801017ba:	e8 91 30 00 00       	call   80104850 <releasesleep>

  acquire(&icache.lock);
801017bf:	c7 04 24 c0 23 11 80 	movl   $0x801123c0,(%esp)
801017c6:	e8 75 32 00 00       	call   80104a40 <acquire>
  ip->ref--;
801017cb:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
801017cf:	83 c4 10             	add    $0x10,%esp
801017d2:	c7 45 08 c0 23 11 80 	movl   $0x801123c0,0x8(%ebp)
}
801017d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017dc:	5b                   	pop    %ebx
801017dd:	5e                   	pop    %esi
801017de:	5f                   	pop    %edi
801017df:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
801017e0:	e9 0b 33 00 00       	jmp    80104af0 <release>
801017e5:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
801017e8:	83 ec 0c             	sub    $0xc,%esp
801017eb:	68 c0 23 11 80       	push   $0x801123c0
801017f0:	e8 4b 32 00 00       	call   80104a40 <acquire>
    int r = ip->ref;
801017f5:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
801017f8:	c7 04 24 c0 23 11 80 	movl   $0x801123c0,(%esp)
801017ff:	e8 ec 32 00 00       	call   80104af0 <release>
    if(r == 1){
80101804:	83 c4 10             	add    $0x10,%esp
80101807:	83 fb 01             	cmp    $0x1,%ebx
8010180a:	75 aa                	jne    801017b6 <iput+0x26>
8010180c:	8d 8e 8c 00 00 00    	lea    0x8c(%esi),%ecx
80101812:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101815:	8d 5e 5c             	lea    0x5c(%esi),%ebx
80101818:	89 cf                	mov    %ecx,%edi
8010181a:	eb 0b                	jmp    80101827 <iput+0x97>
8010181c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101820:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101823:	39 fb                	cmp    %edi,%ebx
80101825:	74 19                	je     80101840 <iput+0xb0>
    if(ip->addrs[i]){
80101827:	8b 13                	mov    (%ebx),%edx
80101829:	85 d2                	test   %edx,%edx
8010182b:	74 f3                	je     80101820 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010182d:	8b 06                	mov    (%esi),%eax
8010182f:	e8 cc f8 ff ff       	call   80101100 <bfree>
      ip->addrs[i] = 0;
80101834:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010183a:	eb e4                	jmp    80101820 <iput+0x90>
8010183c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101840:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101846:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101849:	85 c0                	test   %eax,%eax
8010184b:	75 33                	jne    80101880 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010184d:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101850:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101857:	56                   	push   %esi
80101858:	e8 53 fd ff ff       	call   801015b0 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
8010185d:	31 c0                	xor    %eax,%eax
8010185f:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101863:	89 34 24             	mov    %esi,(%esp)
80101866:	e8 45 fd ff ff       	call   801015b0 <iupdate>
      ip->valid = 0;
8010186b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101872:	83 c4 10             	add    $0x10,%esp
80101875:	e9 3c ff ff ff       	jmp    801017b6 <iput+0x26>
8010187a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101880:	83 ec 08             	sub    $0x8,%esp
80101883:	50                   	push   %eax
80101884:	ff 36                	pushl  (%esi)
80101886:	e8 45 e8 ff ff       	call   801000d0 <bread>
8010188b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101891:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101894:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101897:	8d 58 5c             	lea    0x5c(%eax),%ebx
8010189a:	83 c4 10             	add    $0x10,%esp
8010189d:	89 cf                	mov    %ecx,%edi
8010189f:	eb 0e                	jmp    801018af <iput+0x11f>
801018a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018a8:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
801018ab:	39 fb                	cmp    %edi,%ebx
801018ad:	74 0f                	je     801018be <iput+0x12e>
      if(a[j])
801018af:	8b 13                	mov    (%ebx),%edx
801018b1:	85 d2                	test   %edx,%edx
801018b3:	74 f3                	je     801018a8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018b5:	8b 06                	mov    (%esi),%eax
801018b7:	e8 44 f8 ff ff       	call   80101100 <bfree>
801018bc:	eb ea                	jmp    801018a8 <iput+0x118>
    }
    brelse(bp);
801018be:	83 ec 0c             	sub    $0xc,%esp
801018c1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018c4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018c7:	e8 14 e9 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018cc:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018d2:	8b 06                	mov    (%esi),%eax
801018d4:	e8 27 f8 ff ff       	call   80101100 <bfree>
    ip->addrs[NDIRECT] = 0;
801018d9:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801018e0:	00 00 00 
801018e3:	83 c4 10             	add    $0x10,%esp
801018e6:	e9 62 ff ff ff       	jmp    8010184d <iput+0xbd>
801018eb:	90                   	nop
801018ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018f0 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
801018f0:	55                   	push   %ebp
801018f1:	89 e5                	mov    %esp,%ebp
801018f3:	53                   	push   %ebx
801018f4:	83 ec 10             	sub    $0x10,%esp
801018f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801018fa:	53                   	push   %ebx
801018fb:	e8 40 fe ff ff       	call   80101740 <iunlock>
  iput(ip);
80101900:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101903:	83 c4 10             	add    $0x10,%esp
}
80101906:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101909:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010190a:	e9 81 fe ff ff       	jmp    80101790 <iput>
8010190f:	90                   	nop

80101910 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	8b 55 08             	mov    0x8(%ebp),%edx
80101916:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101919:	8b 0a                	mov    (%edx),%ecx
8010191b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010191e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101921:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101924:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101928:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010192b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010192f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101933:	8b 52 58             	mov    0x58(%edx),%edx
80101936:	89 50 10             	mov    %edx,0x10(%eax)
}
80101939:	5d                   	pop    %ebp
8010193a:	c3                   	ret    
8010193b:	90                   	nop
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101940 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	57                   	push   %edi
80101944:	56                   	push   %esi
80101945:	53                   	push   %ebx
80101946:	83 ec 1c             	sub    $0x1c,%esp
80101949:	8b 45 08             	mov    0x8(%ebp),%eax
8010194c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010194f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101952:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101957:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010195a:	8b 7d 14             	mov    0x14(%ebp),%edi
8010195d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101960:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101963:	0f 84 a7 00 00 00    	je     80101a10 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101969:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010196c:	8b 40 58             	mov    0x58(%eax),%eax
8010196f:	39 f0                	cmp    %esi,%eax
80101971:	0f 82 c1 00 00 00    	jb     80101a38 <readi+0xf8>
80101977:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010197a:	89 fa                	mov    %edi,%edx
8010197c:	01 f2                	add    %esi,%edx
8010197e:	0f 82 b4 00 00 00    	jb     80101a38 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101984:	89 c1                	mov    %eax,%ecx
80101986:	29 f1                	sub    %esi,%ecx
80101988:	39 d0                	cmp    %edx,%eax
8010198a:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010198d:	31 ff                	xor    %edi,%edi
8010198f:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101991:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101994:	74 6d                	je     80101a03 <readi+0xc3>
80101996:	8d 76 00             	lea    0x0(%esi),%esi
80101999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019a0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019a3:	89 f2                	mov    %esi,%edx
801019a5:	c1 ea 09             	shr    $0x9,%edx
801019a8:	89 d8                	mov    %ebx,%eax
801019aa:	e8 a1 f9 ff ff       	call   80101350 <bmap>
801019af:	83 ec 08             	sub    $0x8,%esp
801019b2:	50                   	push   %eax
801019b3:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
801019b5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ba:	e8 11 e7 ff ff       	call   801000d0 <bread>
801019bf:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801019c4:	89 f1                	mov    %esi,%ecx
801019c6:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801019cc:	83 c4 0c             	add    $0xc,%esp
    memmove(dst, bp->data + off%BSIZE, m);
801019cf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019d2:	29 cb                	sub    %ecx,%ebx
801019d4:	29 f8                	sub    %edi,%eax
801019d6:	39 c3                	cmp    %eax,%ebx
801019d8:	0f 47 d8             	cmova  %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019db:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
801019df:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019e0:	01 df                	add    %ebx,%edi
801019e2:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
801019e4:	50                   	push   %eax
801019e5:	ff 75 e0             	pushl  -0x20(%ebp)
801019e8:	e8 03 32 00 00       	call   80104bf0 <memmove>
    brelse(bp);
801019ed:	8b 55 dc             	mov    -0x24(%ebp),%edx
801019f0:	89 14 24             	mov    %edx,(%esp)
801019f3:	e8 e8 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019f8:	01 5d e0             	add    %ebx,-0x20(%ebp)
801019fb:	83 c4 10             	add    $0x10,%esp
801019fe:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a01:	77 9d                	ja     801019a0 <readi+0x60>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a09:	5b                   	pop    %ebx
80101a0a:	5e                   	pop    %esi
80101a0b:	5f                   	pop    %edi
80101a0c:	5d                   	pop    %ebp
80101a0d:	c3                   	ret    
80101a0e:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a10:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a14:	66 83 f8 09          	cmp    $0x9,%ax
80101a18:	77 1e                	ja     80101a38 <readi+0xf8>
80101a1a:	8b 04 c5 40 23 11 80 	mov    -0x7feedcc0(,%eax,8),%eax
80101a21:	85 c0                	test   %eax,%eax
80101a23:	74 13                	je     80101a38 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a25:	89 7d 10             	mov    %edi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a2b:	5b                   	pop    %ebx
80101a2c:	5e                   	pop    %esi
80101a2d:	5f                   	pop    %edi
80101a2e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a2f:	ff e0                	jmp    *%eax
80101a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a3d:	eb c7                	jmp    80101a06 <readi+0xc6>
80101a3f:	90                   	nop

80101a40 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a40:	55                   	push   %ebp
80101a41:	89 e5                	mov    %esp,%ebp
80101a43:	57                   	push   %edi
80101a44:	56                   	push   %esi
80101a45:	53                   	push   %ebx
80101a46:	83 ec 1c             	sub    $0x1c,%esp
80101a49:	8b 45 08             	mov    0x8(%ebp),%eax
80101a4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a4f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a52:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a57:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a5a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a5d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a60:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a63:	0f 84 b7 00 00 00    	je     80101b20 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a6c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a6f:	0f 82 eb 00 00 00    	jb     80101b60 <writei+0x120>
80101a75:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a78:	89 f8                	mov    %edi,%eax
80101a7a:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a7c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a81:	0f 87 d9 00 00 00    	ja     80101b60 <writei+0x120>
80101a87:	39 c6                	cmp    %eax,%esi
80101a89:	0f 87 d1 00 00 00    	ja     80101b60 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a8f:	85 ff                	test   %edi,%edi
80101a91:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101a98:	74 78                	je     80101b12 <writei+0xd2>
80101a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aa0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101aa3:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101aa5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aaa:	c1 ea 09             	shr    $0x9,%edx
80101aad:	89 f8                	mov    %edi,%eax
80101aaf:	e8 9c f8 ff ff       	call   80101350 <bmap>
80101ab4:	83 ec 08             	sub    $0x8,%esp
80101ab7:	50                   	push   %eax
80101ab8:	ff 37                	pushl  (%edi)
80101aba:	e8 11 e6 ff ff       	call   801000d0 <bread>
80101abf:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ac1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ac4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101ac7:	89 f1                	mov    %esi,%ecx
80101ac9:	83 c4 0c             	add    $0xc,%esp
80101acc:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101ad2:	29 cb                	sub    %ecx,%ebx
80101ad4:	39 c3                	cmp    %eax,%ebx
80101ad6:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ad9:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101add:	53                   	push   %ebx
80101ade:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ae1:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101ae3:	50                   	push   %eax
80101ae4:	e8 07 31 00 00       	call   80104bf0 <memmove>
    log_write(bp);
80101ae9:	89 3c 24             	mov    %edi,(%esp)
80101aec:	e8 2f 12 00 00       	call   80102d20 <log_write>
    brelse(bp);
80101af1:	89 3c 24             	mov    %edi,(%esp)
80101af4:	e8 e7 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101af9:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101afc:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101aff:	83 c4 10             	add    $0x10,%esp
80101b02:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101b05:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101b08:	77 96                	ja     80101aa0 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b0a:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b0d:	3b 70 58             	cmp    0x58(%eax),%esi
80101b10:	77 36                	ja     80101b48 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b12:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b15:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b18:	5b                   	pop    %ebx
80101b19:	5e                   	pop    %esi
80101b1a:	5f                   	pop    %edi
80101b1b:	5d                   	pop    %ebp
80101b1c:	c3                   	ret    
80101b1d:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b20:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b24:	66 83 f8 09          	cmp    $0x9,%ax
80101b28:	77 36                	ja     80101b60 <writei+0x120>
80101b2a:	8b 04 c5 44 23 11 80 	mov    -0x7feedcbc(,%eax,8),%eax
80101b31:	85 c0                	test   %eax,%eax
80101b33:	74 2b                	je     80101b60 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b35:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b3b:	5b                   	pop    %ebx
80101b3c:	5e                   	pop    %esi
80101b3d:	5f                   	pop    %edi
80101b3e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b3f:	ff e0                	jmp    *%eax
80101b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b48:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b4b:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b4e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b51:	50                   	push   %eax
80101b52:	e8 59 fa ff ff       	call   801015b0 <iupdate>
80101b57:	83 c4 10             	add    $0x10,%esp
80101b5a:	eb b6                	jmp    80101b12 <writei+0xd2>
80101b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b65:	eb ae                	jmp    80101b15 <writei+0xd5>
80101b67:	89 f6                	mov    %esi,%esi
80101b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b70 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b70:	55                   	push   %ebp
80101b71:	89 e5                	mov    %esp,%ebp
80101b73:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b76:	6a 0e                	push   $0xe
80101b78:	ff 75 0c             	pushl  0xc(%ebp)
80101b7b:	ff 75 08             	pushl  0x8(%ebp)
80101b7e:	e8 ed 30 00 00       	call   80104c70 <strncmp>
}
80101b83:	c9                   	leave  
80101b84:	c3                   	ret    
80101b85:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b90 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 1c             	sub    $0x1c,%esp
80101b99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101b9c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101ba1:	0f 85 80 00 00 00    	jne    80101c27 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101ba7:	8b 53 58             	mov    0x58(%ebx),%edx
80101baa:	31 ff                	xor    %edi,%edi
80101bac:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101baf:	85 d2                	test   %edx,%edx
80101bb1:	75 0d                	jne    80101bc0 <dirlookup+0x30>
80101bb3:	eb 5b                	jmp    80101c10 <dirlookup+0x80>
80101bb5:	8d 76 00             	lea    0x0(%esi),%esi
80101bb8:	83 c7 10             	add    $0x10,%edi
80101bbb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bbe:	76 50                	jbe    80101c10 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bc0:	6a 10                	push   $0x10
80101bc2:	57                   	push   %edi
80101bc3:	56                   	push   %esi
80101bc4:	53                   	push   %ebx
80101bc5:	e8 76 fd ff ff       	call   80101940 <readi>
80101bca:	83 c4 10             	add    $0x10,%esp
80101bcd:	83 f8 10             	cmp    $0x10,%eax
80101bd0:	75 48                	jne    80101c1a <dirlookup+0x8a>
      panic("dirlookup read");
    if(de.inum == 0)
80101bd2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bd7:	74 df                	je     80101bb8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101bd9:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bdc:	83 ec 04             	sub    $0x4,%esp
80101bdf:	6a 0e                	push   $0xe
80101be1:	50                   	push   %eax
80101be2:	ff 75 0c             	pushl  0xc(%ebp)
80101be5:	e8 86 30 00 00       	call   80104c70 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101bea:	83 c4 10             	add    $0x10,%esp
80101bed:	85 c0                	test   %eax,%eax
80101bef:	75 c7                	jne    80101bb8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101bf1:	8b 45 10             	mov    0x10(%ebp),%eax
80101bf4:	85 c0                	test   %eax,%eax
80101bf6:	74 05                	je     80101bfd <dirlookup+0x6d>
        *poff = off;
80101bf8:	8b 45 10             	mov    0x10(%ebp),%eax
80101bfb:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101bfd:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101c01:	8b 03                	mov    (%ebx),%eax
80101c03:	e8 78 f6 ff ff       	call   80101280 <iget>
    }
  }

  return 0;
}
80101c08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c0b:	5b                   	pop    %ebx
80101c0c:	5e                   	pop    %esi
80101c0d:	5f                   	pop    %edi
80101c0e:	5d                   	pop    %ebp
80101c0f:	c3                   	ret    
80101c10:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101c13:	31 c0                	xor    %eax,%eax
}
80101c15:	5b                   	pop    %ebx
80101c16:	5e                   	pop    %esi
80101c17:	5f                   	pop    %edi
80101c18:	5d                   	pop    %ebp
80101c19:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101c1a:	83 ec 0c             	sub    $0xc,%esp
80101c1d:	68 79 7a 10 80       	push   $0x80107a79
80101c22:	e8 49 e7 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c27:	83 ec 0c             	sub    $0xc,%esp
80101c2a:	68 67 7a 10 80       	push   $0x80107a67
80101c2f:	e8 3c e7 ff ff       	call   80100370 <panic>
80101c34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101c3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101c40 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c40:	55                   	push   %ebp
80101c41:	89 e5                	mov    %esp,%ebp
80101c43:	57                   	push   %edi
80101c44:	56                   	push   %esi
80101c45:	53                   	push   %ebx
80101c46:	89 cf                	mov    %ecx,%edi
80101c48:	89 c3                	mov    %eax,%ebx
80101c4a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c4d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c50:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101c53:	0f 84 53 01 00 00    	je     80101dac <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c59:	e8 92 1b 00 00       	call   801037f0 <myproc>
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c5e:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c61:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c64:	68 c0 23 11 80       	push   $0x801123c0
80101c69:	e8 d2 2d 00 00       	call   80104a40 <acquire>
  ip->ref++;
80101c6e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c72:	c7 04 24 c0 23 11 80 	movl   $0x801123c0,(%esp)
80101c79:	e8 72 2e 00 00       	call   80104af0 <release>
80101c7e:	83 c4 10             	add    $0x10,%esp
80101c81:	eb 08                	jmp    80101c8b <namex+0x4b>
80101c83:	90                   	nop
80101c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101c88:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101c8b:	0f b6 03             	movzbl (%ebx),%eax
80101c8e:	3c 2f                	cmp    $0x2f,%al
80101c90:	74 f6                	je     80101c88 <namex+0x48>
    path++;
  if(*path == 0)
80101c92:	84 c0                	test   %al,%al
80101c94:	0f 84 e3 00 00 00    	je     80101d7d <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101c9a:	0f b6 03             	movzbl (%ebx),%eax
80101c9d:	89 da                	mov    %ebx,%edx
80101c9f:	84 c0                	test   %al,%al
80101ca1:	0f 84 ac 00 00 00    	je     80101d53 <namex+0x113>
80101ca7:	3c 2f                	cmp    $0x2f,%al
80101ca9:	75 09                	jne    80101cb4 <namex+0x74>
80101cab:	e9 a3 00 00 00       	jmp    80101d53 <namex+0x113>
80101cb0:	84 c0                	test   %al,%al
80101cb2:	74 0a                	je     80101cbe <namex+0x7e>
    path++;
80101cb4:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cb7:	0f b6 02             	movzbl (%edx),%eax
80101cba:	3c 2f                	cmp    $0x2f,%al
80101cbc:	75 f2                	jne    80101cb0 <namex+0x70>
80101cbe:	89 d1                	mov    %edx,%ecx
80101cc0:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101cc2:	83 f9 0d             	cmp    $0xd,%ecx
80101cc5:	0f 8e 8d 00 00 00    	jle    80101d58 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101ccb:	83 ec 04             	sub    $0x4,%esp
80101cce:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cd1:	6a 0e                	push   $0xe
80101cd3:	53                   	push   %ebx
80101cd4:	57                   	push   %edi
80101cd5:	e8 16 2f 00 00       	call   80104bf0 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101cda:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101cdd:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101ce0:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101ce2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101ce5:	75 11                	jne    80101cf8 <namex+0xb8>
80101ce7:	89 f6                	mov    %esi,%esi
80101ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101cf0:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101cf3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101cf6:	74 f8                	je     80101cf0 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101cf8:	83 ec 0c             	sub    $0xc,%esp
80101cfb:	56                   	push   %esi
80101cfc:	e8 5f f9 ff ff       	call   80101660 <ilock>
    if(ip->type != T_DIR){
80101d01:	83 c4 10             	add    $0x10,%esp
80101d04:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d09:	0f 85 7f 00 00 00    	jne    80101d8e <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d0f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d12:	85 d2                	test   %edx,%edx
80101d14:	74 09                	je     80101d1f <namex+0xdf>
80101d16:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d19:	0f 84 a3 00 00 00    	je     80101dc2 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d1f:	83 ec 04             	sub    $0x4,%esp
80101d22:	6a 00                	push   $0x0
80101d24:	57                   	push   %edi
80101d25:	56                   	push   %esi
80101d26:	e8 65 fe ff ff       	call   80101b90 <dirlookup>
80101d2b:	83 c4 10             	add    $0x10,%esp
80101d2e:	85 c0                	test   %eax,%eax
80101d30:	74 5c                	je     80101d8e <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d32:	83 ec 0c             	sub    $0xc,%esp
80101d35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d38:	56                   	push   %esi
80101d39:	e8 02 fa ff ff       	call   80101740 <iunlock>
  iput(ip);
80101d3e:	89 34 24             	mov    %esi,(%esp)
80101d41:	e8 4a fa ff ff       	call   80101790 <iput>
80101d46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d49:	83 c4 10             	add    $0x10,%esp
80101d4c:	89 c6                	mov    %eax,%esi
80101d4e:	e9 38 ff ff ff       	jmp    80101c8b <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d53:	31 c9                	xor    %ecx,%ecx
80101d55:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101d58:	83 ec 04             	sub    $0x4,%esp
80101d5b:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d5e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d61:	51                   	push   %ecx
80101d62:	53                   	push   %ebx
80101d63:	57                   	push   %edi
80101d64:	e8 87 2e 00 00       	call   80104bf0 <memmove>
    name[len] = 0;
80101d69:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d6c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d6f:	83 c4 10             	add    $0x10,%esp
80101d72:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d76:	89 d3                	mov    %edx,%ebx
80101d78:	e9 65 ff ff ff       	jmp    80101ce2 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101d7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d80:	85 c0                	test   %eax,%eax
80101d82:	75 54                	jne    80101dd8 <namex+0x198>
80101d84:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101d86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d89:	5b                   	pop    %ebx
80101d8a:	5e                   	pop    %esi
80101d8b:	5f                   	pop    %edi
80101d8c:	5d                   	pop    %ebp
80101d8d:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d8e:	83 ec 0c             	sub    $0xc,%esp
80101d91:	56                   	push   %esi
80101d92:	e8 a9 f9 ff ff       	call   80101740 <iunlock>
  iput(ip);
80101d97:	89 34 24             	mov    %esi,(%esp)
80101d9a:	e8 f1 f9 ff ff       	call   80101790 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101d9f:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101da2:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101da5:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101da7:	5b                   	pop    %ebx
80101da8:	5e                   	pop    %esi
80101da9:	5f                   	pop    %edi
80101daa:	5d                   	pop    %ebp
80101dab:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101dac:	ba 01 00 00 00       	mov    $0x1,%edx
80101db1:	b8 01 00 00 00       	mov    $0x1,%eax
80101db6:	e8 c5 f4 ff ff       	call   80101280 <iget>
80101dbb:	89 c6                	mov    %eax,%esi
80101dbd:	e9 c9 fe ff ff       	jmp    80101c8b <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101dc2:	83 ec 0c             	sub    $0xc,%esp
80101dc5:	56                   	push   %esi
80101dc6:	e8 75 f9 ff ff       	call   80101740 <iunlock>
      return ip;
80101dcb:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dce:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101dd1:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dd3:	5b                   	pop    %ebx
80101dd4:	5e                   	pop    %esi
80101dd5:	5f                   	pop    %edi
80101dd6:	5d                   	pop    %ebp
80101dd7:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101dd8:	83 ec 0c             	sub    $0xc,%esp
80101ddb:	56                   	push   %esi
80101ddc:	e8 af f9 ff ff       	call   80101790 <iput>
    return 0;
80101de1:	83 c4 10             	add    $0x10,%esp
80101de4:	31 c0                	xor    %eax,%eax
80101de6:	eb 9e                	jmp    80101d86 <namex+0x146>
80101de8:	90                   	nop
80101de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101df0 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101df0:	55                   	push   %ebp
80101df1:	89 e5                	mov    %esp,%ebp
80101df3:	57                   	push   %edi
80101df4:	56                   	push   %esi
80101df5:	53                   	push   %ebx
80101df6:	83 ec 20             	sub    $0x20,%esp
80101df9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101dfc:	6a 00                	push   $0x0
80101dfe:	ff 75 0c             	pushl  0xc(%ebp)
80101e01:	53                   	push   %ebx
80101e02:	e8 89 fd ff ff       	call   80101b90 <dirlookup>
80101e07:	83 c4 10             	add    $0x10,%esp
80101e0a:	85 c0                	test   %eax,%eax
80101e0c:	75 67                	jne    80101e75 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e0e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e11:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e14:	85 ff                	test   %edi,%edi
80101e16:	74 29                	je     80101e41 <dirlink+0x51>
80101e18:	31 ff                	xor    %edi,%edi
80101e1a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e1d:	eb 09                	jmp    80101e28 <dirlink+0x38>
80101e1f:	90                   	nop
80101e20:	83 c7 10             	add    $0x10,%edi
80101e23:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101e26:	76 19                	jbe    80101e41 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e28:	6a 10                	push   $0x10
80101e2a:	57                   	push   %edi
80101e2b:	56                   	push   %esi
80101e2c:	53                   	push   %ebx
80101e2d:	e8 0e fb ff ff       	call   80101940 <readi>
80101e32:	83 c4 10             	add    $0x10,%esp
80101e35:	83 f8 10             	cmp    $0x10,%eax
80101e38:	75 4e                	jne    80101e88 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
80101e3a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e3f:	75 df                	jne    80101e20 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101e41:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e44:	83 ec 04             	sub    $0x4,%esp
80101e47:	6a 0e                	push   $0xe
80101e49:	ff 75 0c             	pushl  0xc(%ebp)
80101e4c:	50                   	push   %eax
80101e4d:	e8 8e 2e 00 00       	call   80104ce0 <strncpy>
  de.inum = inum;
80101e52:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e55:	6a 10                	push   $0x10
80101e57:	57                   	push   %edi
80101e58:	56                   	push   %esi
80101e59:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101e5a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e5e:	e8 dd fb ff ff       	call   80101a40 <writei>
80101e63:	83 c4 20             	add    $0x20,%esp
80101e66:	83 f8 10             	cmp    $0x10,%eax
80101e69:	75 2a                	jne    80101e95 <dirlink+0xa5>
    panic("dirlink");

  return 0;
80101e6b:	31 c0                	xor    %eax,%eax
}
80101e6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e70:	5b                   	pop    %ebx
80101e71:	5e                   	pop    %esi
80101e72:	5f                   	pop    %edi
80101e73:	5d                   	pop    %ebp
80101e74:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101e75:	83 ec 0c             	sub    $0xc,%esp
80101e78:	50                   	push   %eax
80101e79:	e8 12 f9 ff ff       	call   80101790 <iput>
    return -1;
80101e7e:	83 c4 10             	add    $0x10,%esp
80101e81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e86:	eb e5                	jmp    80101e6d <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101e88:	83 ec 0c             	sub    $0xc,%esp
80101e8b:	68 88 7a 10 80       	push   $0x80107a88
80101e90:	e8 db e4 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101e95:	83 ec 0c             	sub    $0xc,%esp
80101e98:	68 0a 82 10 80       	push   $0x8010820a
80101e9d:	e8 ce e4 ff ff       	call   80100370 <panic>
80101ea2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101eb0 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101eb0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101eb1:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101eb3:	89 e5                	mov    %esp,%ebp
80101eb5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101eb8:	8b 45 08             	mov    0x8(%ebp),%eax
80101ebb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101ebe:	e8 7d fd ff ff       	call   80101c40 <namex>
}
80101ec3:	c9                   	leave  
80101ec4:	c3                   	ret    
80101ec5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ed0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101ed0:	55                   	push   %ebp
  return namex(path, 1, name);
80101ed1:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101ed6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101ed8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101edb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101ede:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101edf:	e9 5c fd ff ff       	jmp    80101c40 <namex>
80101ee4:	66 90                	xchg   %ax,%ax
80101ee6:	66 90                	xchg   %ax,%ax
80101ee8:	66 90                	xchg   %ax,%ax
80101eea:	66 90                	xchg   %ax,%ax
80101eec:	66 90                	xchg   %ax,%ax
80101eee:	66 90                	xchg   %ax,%ax

80101ef0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101ef0:	55                   	push   %ebp
  if(b == 0)
80101ef1:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101ef3:	89 e5                	mov    %esp,%ebp
80101ef5:	56                   	push   %esi
80101ef6:	53                   	push   %ebx
  if(b == 0)
80101ef7:	0f 84 ad 00 00 00    	je     80101faa <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101efd:	8b 58 08             	mov    0x8(%eax),%ebx
80101f00:	89 c1                	mov    %eax,%ecx
80101f02:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f08:	0f 87 8f 00 00 00    	ja     80101f9d <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f0e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f13:	90                   	nop
80101f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f18:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f19:	83 e0 c0             	and    $0xffffffc0,%eax
80101f1c:	3c 40                	cmp    $0x40,%al
80101f1e:	75 f8                	jne    80101f18 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f20:	31 f6                	xor    %esi,%esi
80101f22:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f27:	89 f0                	mov    %esi,%eax
80101f29:	ee                   	out    %al,(%dx)
80101f2a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f2f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f34:	ee                   	out    %al,(%dx)
80101f35:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f3a:	89 d8                	mov    %ebx,%eax
80101f3c:	ee                   	out    %al,(%dx)
80101f3d:	89 d8                	mov    %ebx,%eax
80101f3f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f44:	c1 f8 08             	sar    $0x8,%eax
80101f47:	ee                   	out    %al,(%dx)
80101f48:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f4d:	89 f0                	mov    %esi,%eax
80101f4f:	ee                   	out    %al,(%dx)
80101f50:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80101f54:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f59:	83 e0 01             	and    $0x1,%eax
80101f5c:	c1 e0 04             	shl    $0x4,%eax
80101f5f:	83 c8 e0             	or     $0xffffffe0,%eax
80101f62:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80101f63:	f6 01 04             	testb  $0x4,(%ecx)
80101f66:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f6b:	75 13                	jne    80101f80 <idestart+0x90>
80101f6d:	b8 20 00 00 00       	mov    $0x20,%eax
80101f72:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f73:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f76:	5b                   	pop    %ebx
80101f77:	5e                   	pop    %esi
80101f78:	5d                   	pop    %ebp
80101f79:	c3                   	ret    
80101f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f80:	b8 30 00 00 00       	mov    $0x30,%eax
80101f85:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101f86:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101f8b:	8d 71 5c             	lea    0x5c(%ecx),%esi
80101f8e:	b9 80 00 00 00       	mov    $0x80,%ecx
80101f93:	fc                   	cld    
80101f94:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f96:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f99:	5b                   	pop    %ebx
80101f9a:	5e                   	pop    %esi
80101f9b:	5d                   	pop    %ebp
80101f9c:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
80101f9d:	83 ec 0c             	sub    $0xc,%esp
80101fa0:	68 f4 7a 10 80       	push   $0x80107af4
80101fa5:	e8 c6 e3 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101faa:	83 ec 0c             	sub    $0xc,%esp
80101fad:	68 eb 7a 10 80       	push   $0x80107aeb
80101fb2:	e8 b9 e3 ff ff       	call   80100370 <panic>
80101fb7:	89 f6                	mov    %esi,%esi
80101fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fc0 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80101fc0:	55                   	push   %ebp
80101fc1:	89 e5                	mov    %esp,%ebp
80101fc3:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
80101fc6:	68 06 7b 10 80       	push   $0x80107b06
80101fcb:	68 80 b5 10 80       	push   $0x8010b580
80101fd0:	e8 0b 29 00 00       	call   801048e0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101fd5:	58                   	pop    %eax
80101fd6:	a1 e0 46 11 80       	mov    0x801146e0,%eax
80101fdb:	5a                   	pop    %edx
80101fdc:	83 e8 01             	sub    $0x1,%eax
80101fdf:	50                   	push   %eax
80101fe0:	6a 0e                	push   $0xe
80101fe2:	e8 a9 02 00 00       	call   80102290 <ioapicenable>
80101fe7:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101fea:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fef:	90                   	nop
80101ff0:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101ff1:	83 e0 c0             	and    $0xffffffc0,%eax
80101ff4:	3c 40                	cmp    $0x40,%al
80101ff6:	75 f8                	jne    80101ff0 <ideinit+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101ff8:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101ffd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102002:	ee                   	out    %al,(%dx)
80102003:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102008:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010200d:	eb 06                	jmp    80102015 <ideinit+0x55>
8010200f:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102010:	83 e9 01             	sub    $0x1,%ecx
80102013:	74 0f                	je     80102024 <ideinit+0x64>
80102015:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102016:	84 c0                	test   %al,%al
80102018:	74 f6                	je     80102010 <ideinit+0x50>
      havedisk1 = 1;
8010201a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102021:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102024:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102029:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
8010202e:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
8010202f:	c9                   	leave  
80102030:	c3                   	ret    
80102031:	eb 0d                	jmp    80102040 <ideintr>
80102033:	90                   	nop
80102034:	90                   	nop
80102035:	90                   	nop
80102036:	90                   	nop
80102037:	90                   	nop
80102038:	90                   	nop
80102039:	90                   	nop
8010203a:	90                   	nop
8010203b:	90                   	nop
8010203c:	90                   	nop
8010203d:	90                   	nop
8010203e:	90                   	nop
8010203f:	90                   	nop

80102040 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102040:	55                   	push   %ebp
80102041:	89 e5                	mov    %esp,%ebp
80102043:	57                   	push   %edi
80102044:	56                   	push   %esi
80102045:	53                   	push   %ebx
80102046:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102049:	68 80 b5 10 80       	push   $0x8010b580
8010204e:	e8 ed 29 00 00       	call   80104a40 <acquire>

  if((b = idequeue) == 0){
80102053:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102059:	83 c4 10             	add    $0x10,%esp
8010205c:	85 db                	test   %ebx,%ebx
8010205e:	74 34                	je     80102094 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102060:	8b 43 58             	mov    0x58(%ebx),%eax
80102063:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102068:	8b 33                	mov    (%ebx),%esi
8010206a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102070:	74 3e                	je     801020b0 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102072:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102075:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102078:	83 ce 02             	or     $0x2,%esi
8010207b:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010207d:	53                   	push   %ebx
8010207e:	e8 0d 25 00 00       	call   80104590 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102083:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102088:	83 c4 10             	add    $0x10,%esp
8010208b:	85 c0                	test   %eax,%eax
8010208d:	74 05                	je     80102094 <ideintr+0x54>
    idestart(idequeue);
8010208f:	e8 5c fe ff ff       	call   80101ef0 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
80102094:	83 ec 0c             	sub    $0xc,%esp
80102097:	68 80 b5 10 80       	push   $0x8010b580
8010209c:	e8 4f 2a 00 00       	call   80104af0 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
801020a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020a4:	5b                   	pop    %ebx
801020a5:	5e                   	pop    %esi
801020a6:	5f                   	pop    %edi
801020a7:	5d                   	pop    %ebp
801020a8:	c3                   	ret    
801020a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020b0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020b5:	8d 76 00             	lea    0x0(%esi),%esi
801020b8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020b9:	89 c1                	mov    %eax,%ecx
801020bb:	83 e1 c0             	and    $0xffffffc0,%ecx
801020be:	80 f9 40             	cmp    $0x40,%cl
801020c1:	75 f5                	jne    801020b8 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020c3:	a8 21                	test   $0x21,%al
801020c5:	75 ab                	jne    80102072 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
801020c7:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
801020ca:	b9 80 00 00 00       	mov    $0x80,%ecx
801020cf:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020d4:	fc                   	cld    
801020d5:	f3 6d                	rep insl (%dx),%es:(%edi)
801020d7:	8b 33                	mov    (%ebx),%esi
801020d9:	eb 97                	jmp    80102072 <ideintr+0x32>
801020db:	90                   	nop
801020dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	53                   	push   %ebx
801020e4:	83 ec 10             	sub    $0x10,%esp
801020e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801020ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801020ed:	50                   	push   %eax
801020ee:	e8 9d 27 00 00       	call   80104890 <holdingsleep>
801020f3:	83 c4 10             	add    $0x10,%esp
801020f6:	85 c0                	test   %eax,%eax
801020f8:	0f 84 ad 00 00 00    	je     801021ab <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801020fe:	8b 03                	mov    (%ebx),%eax
80102100:	83 e0 06             	and    $0x6,%eax
80102103:	83 f8 02             	cmp    $0x2,%eax
80102106:	0f 84 b9 00 00 00    	je     801021c5 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010210c:	8b 53 04             	mov    0x4(%ebx),%edx
8010210f:	85 d2                	test   %edx,%edx
80102111:	74 0d                	je     80102120 <iderw+0x40>
80102113:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102118:	85 c0                	test   %eax,%eax
8010211a:	0f 84 98 00 00 00    	je     801021b8 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102120:	83 ec 0c             	sub    $0xc,%esp
80102123:	68 80 b5 10 80       	push   $0x8010b580
80102128:	e8 13 29 00 00       	call   80104a40 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010212d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102133:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102136:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010213d:	85 d2                	test   %edx,%edx
8010213f:	75 09                	jne    8010214a <iderw+0x6a>
80102141:	eb 58                	jmp    8010219b <iderw+0xbb>
80102143:	90                   	nop
80102144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102148:	89 c2                	mov    %eax,%edx
8010214a:	8b 42 58             	mov    0x58(%edx),%eax
8010214d:	85 c0                	test   %eax,%eax
8010214f:	75 f7                	jne    80102148 <iderw+0x68>
80102151:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102154:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102156:	3b 1d 64 b5 10 80    	cmp    0x8010b564,%ebx
8010215c:	74 44                	je     801021a2 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010215e:	8b 03                	mov    (%ebx),%eax
80102160:	83 e0 06             	and    $0x6,%eax
80102163:	83 f8 02             	cmp    $0x2,%eax
80102166:	74 23                	je     8010218b <iderw+0xab>
80102168:	90                   	nop
80102169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102170:	83 ec 08             	sub    $0x8,%esp
80102173:	68 80 b5 10 80       	push   $0x8010b580
80102178:	53                   	push   %ebx
80102179:	e8 e2 21 00 00       	call   80104360 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010217e:	8b 03                	mov    (%ebx),%eax
80102180:	83 c4 10             	add    $0x10,%esp
80102183:	83 e0 06             	and    $0x6,%eax
80102186:	83 f8 02             	cmp    $0x2,%eax
80102189:	75 e5                	jne    80102170 <iderw+0x90>
    sleep(b, &idelock);
  }


  release(&idelock);
8010218b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102192:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102195:	c9                   	leave  
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
80102196:	e9 55 29 00 00       	jmp    80104af0 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010219b:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
801021a0:	eb b2                	jmp    80102154 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
801021a2:	89 d8                	mov    %ebx,%eax
801021a4:	e8 47 fd ff ff       	call   80101ef0 <idestart>
801021a9:	eb b3                	jmp    8010215e <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
801021ab:	83 ec 0c             	sub    $0xc,%esp
801021ae:	68 0a 7b 10 80       	push   $0x80107b0a
801021b3:	e8 b8 e1 ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801021b8:	83 ec 0c             	sub    $0xc,%esp
801021bb:	68 35 7b 10 80       	push   $0x80107b35
801021c0:	e8 ab e1 ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801021c5:	83 ec 0c             	sub    $0xc,%esp
801021c8:	68 20 7b 10 80       	push   $0x80107b20
801021cd:	e8 9e e1 ff ff       	call   80100370 <panic>
801021d2:	66 90                	xchg   %ax,%ax
801021d4:	66 90                	xchg   %ax,%ax
801021d6:	66 90                	xchg   %ax,%ax
801021d8:	66 90                	xchg   %ax,%ax
801021da:	66 90                	xchg   %ax,%ax
801021dc:	66 90                	xchg   %ax,%ax
801021de:	66 90                	xchg   %ax,%ax

801021e0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021e0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801021e1:	c7 05 14 40 11 80 00 	movl   $0xfec00000,0x80114014
801021e8:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021eb:	89 e5                	mov    %esp,%ebp
801021ed:	56                   	push   %esi
801021ee:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801021ef:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801021f6:	00 00 00 
  return ioapic->data;
801021f9:	8b 15 14 40 11 80    	mov    0x80114014,%edx
801021ff:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102202:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102208:	8b 0d 14 40 11 80    	mov    0x80114014,%ecx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010220e:	0f b6 15 40 41 11 80 	movzbl 0x80114140,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102215:	89 f0                	mov    %esi,%eax
80102217:	c1 e8 10             	shr    $0x10,%eax
8010221a:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010221d:	8b 41 10             	mov    0x10(%ecx),%eax
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102220:	c1 e8 18             	shr    $0x18,%eax
80102223:	39 d0                	cmp    %edx,%eax
80102225:	74 16                	je     8010223d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102227:	83 ec 0c             	sub    $0xc,%esp
8010222a:	68 54 7b 10 80       	push   $0x80107b54
8010222f:	e8 2c e4 ff ff       	call   80100660 <cprintf>
80102234:	8b 0d 14 40 11 80    	mov    0x80114014,%ecx
8010223a:	83 c4 10             	add    $0x10,%esp
8010223d:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102240:	ba 10 00 00 00       	mov    $0x10,%edx
80102245:	b8 20 00 00 00       	mov    $0x20,%eax
8010224a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102250:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102252:	8b 0d 14 40 11 80    	mov    0x80114014,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102258:	89 c3                	mov    %eax,%ebx
8010225a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102260:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102263:	89 59 10             	mov    %ebx,0x10(%ecx)
80102266:	8d 5a 01             	lea    0x1(%edx),%ebx
80102269:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010226c:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010226e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102270:	8b 0d 14 40 11 80    	mov    0x80114014,%ecx
80102276:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010227d:	75 d1                	jne    80102250 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010227f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102282:	5b                   	pop    %ebx
80102283:	5e                   	pop    %esi
80102284:	5d                   	pop    %ebp
80102285:	c3                   	ret    
80102286:	8d 76 00             	lea    0x0(%esi),%esi
80102289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102290 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102290:	55                   	push   %ebp
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102291:	8b 0d 14 40 11 80    	mov    0x80114014,%ecx
  }
}

void
ioapicenable(int irq, int cpunum)
{
80102297:	89 e5                	mov    %esp,%ebp
80102299:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010229c:	8d 50 20             	lea    0x20(%eax),%edx
8010229f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022a3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022a5:	8b 0d 14 40 11 80    	mov    0x80114014,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022ab:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022ae:	89 51 10             	mov    %edx,0x10(%ecx)
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022b1:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022b4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022b6:	a1 14 40 11 80       	mov    0x80114014,%eax
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022bb:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022be:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801022c1:	5d                   	pop    %ebp
801022c2:	c3                   	ret    
801022c3:	66 90                	xchg   %ax,%ax
801022c5:	66 90                	xchg   %ax,%ax
801022c7:	66 90                	xchg   %ax,%ax
801022c9:	66 90                	xchg   %ax,%ax
801022cb:	66 90                	xchg   %ax,%ax
801022cd:	66 90                	xchg   %ax,%ax
801022cf:	90                   	nop

801022d0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022d0:	55                   	push   %ebp
801022d1:	89 e5                	mov    %esp,%ebp
801022d3:	53                   	push   %ebx
801022d4:	83 ec 04             	sub    $0x4,%esp
801022d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022da:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801022e0:	75 70                	jne    80102352 <kfree+0x82>
801022e2:	81 fb 88 76 11 80    	cmp    $0x80117688,%ebx
801022e8:	72 68                	jb     80102352 <kfree+0x82>
801022ea:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801022f0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801022f5:	77 5b                	ja     80102352 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801022f7:	83 ec 04             	sub    $0x4,%esp
801022fa:	68 00 10 00 00       	push   $0x1000
801022ff:	6a 01                	push   $0x1
80102301:	53                   	push   %ebx
80102302:	e8 39 28 00 00       	call   80104b40 <memset>

  if(kmem.use_lock)
80102307:	8b 15 54 40 11 80    	mov    0x80114054,%edx
8010230d:	83 c4 10             	add    $0x10,%esp
80102310:	85 d2                	test   %edx,%edx
80102312:	75 2c                	jne    80102340 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102314:	a1 58 40 11 80       	mov    0x80114058,%eax
80102319:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010231b:	a1 54 40 11 80       	mov    0x80114054,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102320:	89 1d 58 40 11 80    	mov    %ebx,0x80114058
  if(kmem.use_lock)
80102326:	85 c0                	test   %eax,%eax
80102328:	75 06                	jne    80102330 <kfree+0x60>
    release(&kmem.lock);
}
8010232a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010232d:	c9                   	leave  
8010232e:	c3                   	ret    
8010232f:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102330:	c7 45 08 20 40 11 80 	movl   $0x80114020,0x8(%ebp)
}
80102337:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010233a:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
8010233b:	e9 b0 27 00 00       	jmp    80104af0 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102340:	83 ec 0c             	sub    $0xc,%esp
80102343:	68 20 40 11 80       	push   $0x80114020
80102348:	e8 f3 26 00 00       	call   80104a40 <acquire>
8010234d:	83 c4 10             	add    $0x10,%esp
80102350:	eb c2                	jmp    80102314 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102352:	83 ec 0c             	sub    $0xc,%esp
80102355:	68 86 7b 10 80       	push   $0x80107b86
8010235a:	e8 11 e0 ff ff       	call   80100370 <panic>
8010235f:	90                   	nop

80102360 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102360:	55                   	push   %ebp
80102361:	89 e5                	mov    %esp,%ebp
80102363:	56                   	push   %esi
80102364:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102365:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102368:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010236b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102371:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102377:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010237d:	39 de                	cmp    %ebx,%esi
8010237f:	72 23                	jb     801023a4 <freerange+0x44>
80102381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102388:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010238e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102391:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102397:	50                   	push   %eax
80102398:	e8 33 ff ff ff       	call   801022d0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010239d:	83 c4 10             	add    $0x10,%esp
801023a0:	39 f3                	cmp    %esi,%ebx
801023a2:	76 e4                	jbe    80102388 <freerange+0x28>
    kfree(p);
}
801023a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023a7:	5b                   	pop    %ebx
801023a8:	5e                   	pop    %esi
801023a9:	5d                   	pop    %ebp
801023aa:	c3                   	ret    
801023ab:	90                   	nop
801023ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023b0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801023b0:	55                   	push   %ebp
801023b1:	89 e5                	mov    %esp,%ebp
801023b3:	56                   	push   %esi
801023b4:	53                   	push   %ebx
801023b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023b8:	83 ec 08             	sub    $0x8,%esp
801023bb:	68 8c 7b 10 80       	push   $0x80107b8c
801023c0:	68 20 40 11 80       	push   $0x80114020
801023c5:	e8 16 25 00 00       	call   801048e0 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023ca:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023cd:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
801023d0:	c7 05 54 40 11 80 00 	movl   $0x0,0x80114054
801023d7:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023da:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023e0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023e6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023ec:	39 de                	cmp    %ebx,%esi
801023ee:	72 1c                	jb     8010240c <kinit1+0x5c>
    kfree(p);
801023f0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023f6:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023f9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023ff:	50                   	push   %eax
80102400:	e8 cb fe ff ff       	call   801022d0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102405:	83 c4 10             	add    $0x10,%esp
80102408:	39 de                	cmp    %ebx,%esi
8010240a:	73 e4                	jae    801023f0 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010240c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010240f:	5b                   	pop    %ebx
80102410:	5e                   	pop    %esi
80102411:	5d                   	pop    %ebp
80102412:	c3                   	ret    
80102413:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102420 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102420:	55                   	push   %ebp
80102421:	89 e5                	mov    %esp,%ebp
80102423:	56                   	push   %esi
80102424:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102425:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
80102428:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010242b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102431:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102437:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010243d:	39 de                	cmp    %ebx,%esi
8010243f:	72 23                	jb     80102464 <kinit2+0x44>
80102441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102448:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010244e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102451:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102457:	50                   	push   %eax
80102458:	e8 73 fe ff ff       	call   801022d0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010245d:	83 c4 10             	add    $0x10,%esp
80102460:	39 de                	cmp    %ebx,%esi
80102462:	73 e4                	jae    80102448 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
80102464:	c7 05 54 40 11 80 01 	movl   $0x1,0x80114054
8010246b:	00 00 00 
}
8010246e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102471:	5b                   	pop    %ebx
80102472:	5e                   	pop    %esi
80102473:	5d                   	pop    %ebp
80102474:	c3                   	ret    
80102475:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102480 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102480:	55                   	push   %ebp
80102481:	89 e5                	mov    %esp,%ebp
80102483:	53                   	push   %ebx
80102484:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102487:	a1 54 40 11 80       	mov    0x80114054,%eax
8010248c:	85 c0                	test   %eax,%eax
8010248e:	75 30                	jne    801024c0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102490:	8b 1d 58 40 11 80    	mov    0x80114058,%ebx
  if(r)
80102496:	85 db                	test   %ebx,%ebx
80102498:	74 1c                	je     801024b6 <kalloc+0x36>
    kmem.freelist = r->next;
8010249a:	8b 13                	mov    (%ebx),%edx
8010249c:	89 15 58 40 11 80    	mov    %edx,0x80114058
  if(kmem.use_lock)
801024a2:	85 c0                	test   %eax,%eax
801024a4:	74 10                	je     801024b6 <kalloc+0x36>
    release(&kmem.lock);
801024a6:	83 ec 0c             	sub    $0xc,%esp
801024a9:	68 20 40 11 80       	push   $0x80114020
801024ae:	e8 3d 26 00 00       	call   80104af0 <release>
801024b3:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
801024b6:	89 d8                	mov    %ebx,%eax
801024b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024bb:	c9                   	leave  
801024bc:	c3                   	ret    
801024bd:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801024c0:	83 ec 0c             	sub    $0xc,%esp
801024c3:	68 20 40 11 80       	push   $0x80114020
801024c8:	e8 73 25 00 00       	call   80104a40 <acquire>
  r = kmem.freelist;
801024cd:	8b 1d 58 40 11 80    	mov    0x80114058,%ebx
  if(r)
801024d3:	83 c4 10             	add    $0x10,%esp
801024d6:	a1 54 40 11 80       	mov    0x80114054,%eax
801024db:	85 db                	test   %ebx,%ebx
801024dd:	75 bb                	jne    8010249a <kalloc+0x1a>
801024df:	eb c1                	jmp    801024a2 <kalloc+0x22>
801024e1:	66 90                	xchg   %ax,%ax
801024e3:	66 90                	xchg   %ax,%ax
801024e5:	66 90                	xchg   %ax,%ax
801024e7:	66 90                	xchg   %ax,%ax
801024e9:	66 90                	xchg   %ax,%ax
801024eb:	66 90                	xchg   %ax,%ax
801024ed:	66 90                	xchg   %ax,%ax
801024ef:	90                   	nop

801024f0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801024f0:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024f1:	ba 64 00 00 00       	mov    $0x64,%edx
801024f6:	89 e5                	mov    %esp,%ebp
801024f8:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801024f9:	a8 01                	test   $0x1,%al
801024fb:	0f 84 af 00 00 00    	je     801025b0 <kbdgetc+0xc0>
80102501:	ba 60 00 00 00       	mov    $0x60,%edx
80102506:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102507:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010250a:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102510:	74 7e                	je     80102590 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102512:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102514:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
8010251a:	79 24                	jns    80102540 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010251c:	f6 c1 40             	test   $0x40,%cl
8010251f:	75 05                	jne    80102526 <kbdgetc+0x36>
80102521:	89 c2                	mov    %eax,%edx
80102523:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102526:	0f b6 82 c0 7c 10 80 	movzbl -0x7fef8340(%edx),%eax
8010252d:	83 c8 40             	or     $0x40,%eax
80102530:	0f b6 c0             	movzbl %al,%eax
80102533:	f7 d0                	not    %eax
80102535:	21 c8                	and    %ecx,%eax
80102537:	a3 b4 b5 10 80       	mov    %eax,0x8010b5b4
    return 0;
8010253c:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010253e:	5d                   	pop    %ebp
8010253f:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102540:	f6 c1 40             	test   $0x40,%cl
80102543:	74 09                	je     8010254e <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102545:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102548:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010254b:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
8010254e:	0f b6 82 c0 7c 10 80 	movzbl -0x7fef8340(%edx),%eax
80102555:	09 c1                	or     %eax,%ecx
80102557:	0f b6 82 c0 7b 10 80 	movzbl -0x7fef8440(%edx),%eax
8010255e:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102560:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102562:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102568:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010256b:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010256e:	8b 04 85 a0 7b 10 80 	mov    -0x7fef8460(,%eax,4),%eax
80102575:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102579:	74 c3                	je     8010253e <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
8010257b:	8d 50 9f             	lea    -0x61(%eax),%edx
8010257e:	83 fa 19             	cmp    $0x19,%edx
80102581:	77 1d                	ja     801025a0 <kbdgetc+0xb0>
      c += 'A' - 'a';
80102583:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102586:	5d                   	pop    %ebp
80102587:	c3                   	ret    
80102588:	90                   	nop
80102589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
80102590:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102592:	83 0d b4 b5 10 80 40 	orl    $0x40,0x8010b5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102599:	5d                   	pop    %ebp
8010259a:	c3                   	ret    
8010259b:	90                   	nop
8010259c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801025a0:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025a3:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
801025a6:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
801025a7:	83 f9 19             	cmp    $0x19,%ecx
801025aa:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
801025ad:	c3                   	ret    
801025ae:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801025b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025b5:	5d                   	pop    %ebp
801025b6:	c3                   	ret    
801025b7:	89 f6                	mov    %esi,%esi
801025b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025c0 <kbdintr>:

void
kbdintr(void)
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801025c6:	68 f0 24 10 80       	push   $0x801024f0
801025cb:	e8 20 e2 ff ff       	call   801007f0 <consoleintr>
}
801025d0:	83 c4 10             	add    $0x10,%esp
801025d3:	c9                   	leave  
801025d4:	c3                   	ret    
801025d5:	66 90                	xchg   %ax,%ax
801025d7:	66 90                	xchg   %ax,%ax
801025d9:	66 90                	xchg   %ax,%ax
801025db:	66 90                	xchg   %ax,%ax
801025dd:	66 90                	xchg   %ax,%ax
801025df:	90                   	nop

801025e0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801025e0:	a1 5c 40 11 80       	mov    0x8011405c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801025e5:	55                   	push   %ebp
801025e6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801025e8:	85 c0                	test   %eax,%eax
801025ea:	0f 84 c8 00 00 00    	je     801026b8 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025f0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801025f7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025fa:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025fd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102604:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102607:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010260a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102611:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102614:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102617:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010261e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102621:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102624:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010262b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010262e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102631:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102638:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010263b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010263e:	8b 50 30             	mov    0x30(%eax),%edx
80102641:	c1 ea 10             	shr    $0x10,%edx
80102644:	80 fa 03             	cmp    $0x3,%dl
80102647:	77 77                	ja     801026c0 <lapicinit+0xe0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102649:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102650:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102653:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102656:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010265d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102660:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102663:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010266a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010266d:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102670:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102677:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010267a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010267d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102684:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102687:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010268a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102691:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102694:	8b 50 20             	mov    0x20(%eax),%edx
80102697:	89 f6                	mov    %esi,%esi
80102699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801026a0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801026a6:	80 e6 10             	and    $0x10,%dh
801026a9:	75 f5                	jne    801026a0 <lapicinit+0xc0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026ab:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801026b2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026b5:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801026b8:	5d                   	pop    %ebp
801026b9:	c3                   	ret    
801026ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026c0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801026c7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ca:	8b 50 20             	mov    0x20(%eax),%edx
801026cd:	e9 77 ff ff ff       	jmp    80102649 <lapicinit+0x69>
801026d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026e0 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
801026e0:	a1 5c 40 11 80       	mov    0x8011405c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
801026e5:	55                   	push   %ebp
801026e6:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801026e8:	85 c0                	test   %eax,%eax
801026ea:	74 0c                	je     801026f8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801026ec:	8b 40 20             	mov    0x20(%eax),%eax
}
801026ef:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
801026f0:	c1 e8 18             	shr    $0x18,%eax
}
801026f3:	c3                   	ret    
801026f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
801026f8:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
801026fa:	5d                   	pop    %ebp
801026fb:	c3                   	ret    
801026fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102700 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102700:	a1 5c 40 11 80       	mov    0x8011405c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102705:	55                   	push   %ebp
80102706:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102708:	85 c0                	test   %eax,%eax
8010270a:	74 0d                	je     80102719 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010270c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102713:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102716:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102719:	5d                   	pop    %ebp
8010271a:	c3                   	ret    
8010271b:	90                   	nop
8010271c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102720 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102720:	55                   	push   %ebp
80102721:	89 e5                	mov    %esp,%ebp
}
80102723:	5d                   	pop    %ebp
80102724:	c3                   	ret    
80102725:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102730 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102730:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102731:	ba 70 00 00 00       	mov    $0x70,%edx
80102736:	b8 0f 00 00 00       	mov    $0xf,%eax
8010273b:	89 e5                	mov    %esp,%ebp
8010273d:	53                   	push   %ebx
8010273e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102741:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102744:	ee                   	out    %al,(%dx)
80102745:	ba 71 00 00 00       	mov    $0x71,%edx
8010274a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010274f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102750:	31 c0                	xor    %eax,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102752:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102755:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010275b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010275d:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102760:	c1 e8 04             	shr    $0x4,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102763:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102765:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102768:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010276e:	a1 5c 40 11 80       	mov    0x8011405c,%eax
80102773:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102779:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010277c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102783:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102786:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102789:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102790:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102793:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102796:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010279c:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010279f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027a5:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027a8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027ae:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027b1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027b7:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801027ba:	5b                   	pop    %ebx
801027bb:	5d                   	pop    %ebp
801027bc:	c3                   	ret    
801027bd:	8d 76 00             	lea    0x0(%esi),%esi

801027c0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801027c0:	55                   	push   %ebp
801027c1:	ba 70 00 00 00       	mov    $0x70,%edx
801027c6:	b8 0b 00 00 00       	mov    $0xb,%eax
801027cb:	89 e5                	mov    %esp,%ebp
801027cd:	57                   	push   %edi
801027ce:	56                   	push   %esi
801027cf:	53                   	push   %ebx
801027d0:	83 ec 4c             	sub    $0x4c,%esp
801027d3:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027d4:	ba 71 00 00 00       	mov    $0x71,%edx
801027d9:	ec                   	in     (%dx),%al
801027da:	83 e0 04             	and    $0x4,%eax
801027dd:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027e0:	31 db                	xor    %ebx,%ebx
801027e2:	88 45 b7             	mov    %al,-0x49(%ebp)
801027e5:	bf 70 00 00 00       	mov    $0x70,%edi
801027ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801027f0:	89 d8                	mov    %ebx,%eax
801027f2:	89 fa                	mov    %edi,%edx
801027f4:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027f5:	b9 71 00 00 00       	mov    $0x71,%ecx
801027fa:	89 ca                	mov    %ecx,%edx
801027fc:	ec                   	in     (%dx),%al
}

static void
fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
801027fd:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102800:	89 fa                	mov    %edi,%edx
80102802:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102805:	b8 02 00 00 00       	mov    $0x2,%eax
8010280a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010280b:	89 ca                	mov    %ecx,%edx
8010280d:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
8010280e:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102811:	89 fa                	mov    %edi,%edx
80102813:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102816:	b8 04 00 00 00       	mov    $0x4,%eax
8010281b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010281c:	89 ca                	mov    %ecx,%edx
8010281e:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
8010281f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102822:	89 fa                	mov    %edi,%edx
80102824:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102827:	b8 07 00 00 00       	mov    $0x7,%eax
8010282c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010282d:	89 ca                	mov    %ecx,%edx
8010282f:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102830:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102833:	89 fa                	mov    %edi,%edx
80102835:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102838:	b8 08 00 00 00       	mov    $0x8,%eax
8010283d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010283e:	89 ca                	mov    %ecx,%edx
80102840:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102841:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102844:	89 fa                	mov    %edi,%edx
80102846:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102849:	b8 09 00 00 00       	mov    $0x9,%eax
8010284e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010284f:	89 ca                	mov    %ecx,%edx
80102851:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102852:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102855:	89 fa                	mov    %edi,%edx
80102857:	89 45 cc             	mov    %eax,-0x34(%ebp)
8010285a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010285f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102860:	89 ca                	mov    %ecx,%edx
80102862:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102863:	84 c0                	test   %al,%al
80102865:	78 89                	js     801027f0 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102867:	89 d8                	mov    %ebx,%eax
80102869:	89 fa                	mov    %edi,%edx
8010286b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010286c:	89 ca                	mov    %ecx,%edx
8010286e:	ec                   	in     (%dx),%al
}

static void
fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010286f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102872:	89 fa                	mov    %edi,%edx
80102874:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102877:	b8 02 00 00 00       	mov    $0x2,%eax
8010287c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287d:	89 ca                	mov    %ecx,%edx
8010287f:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102880:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102883:	89 fa                	mov    %edi,%edx
80102885:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102888:	b8 04 00 00 00       	mov    $0x4,%eax
8010288d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288e:	89 ca                	mov    %ecx,%edx
80102890:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102891:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102894:	89 fa                	mov    %edi,%edx
80102896:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102899:	b8 07 00 00 00       	mov    $0x7,%eax
8010289e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289f:	89 ca                	mov    %ecx,%edx
801028a1:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
801028a2:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a5:	89 fa                	mov    %edi,%edx
801028a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801028aa:	b8 08 00 00 00       	mov    $0x8,%eax
801028af:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028b0:	89 ca                	mov    %ecx,%edx
801028b2:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
801028b3:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b6:	89 fa                	mov    %edi,%edx
801028b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801028bb:	b8 09 00 00 00       	mov    $0x9,%eax
801028c0:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028c1:	89 ca                	mov    %ecx,%edx
801028c3:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
801028c4:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028c7:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
801028ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028cd:	8d 45 b8             	lea    -0x48(%ebp),%eax
801028d0:	6a 18                	push   $0x18
801028d2:	56                   	push   %esi
801028d3:	50                   	push   %eax
801028d4:	e8 b7 22 00 00       	call   80104b90 <memcmp>
801028d9:	83 c4 10             	add    $0x10,%esp
801028dc:	85 c0                	test   %eax,%eax
801028de:	0f 85 0c ff ff ff    	jne    801027f0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
801028e4:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801028e8:	75 78                	jne    80102962 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801028ea:	8b 45 b8             	mov    -0x48(%ebp),%eax
801028ed:	89 c2                	mov    %eax,%edx
801028ef:	83 e0 0f             	and    $0xf,%eax
801028f2:	c1 ea 04             	shr    $0x4,%edx
801028f5:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028f8:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028fb:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801028fe:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102901:	89 c2                	mov    %eax,%edx
80102903:	83 e0 0f             	and    $0xf,%eax
80102906:	c1 ea 04             	shr    $0x4,%edx
80102909:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010290c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010290f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102912:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102915:	89 c2                	mov    %eax,%edx
80102917:	83 e0 0f             	and    $0xf,%eax
8010291a:	c1 ea 04             	shr    $0x4,%edx
8010291d:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102920:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102923:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102926:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102929:	89 c2                	mov    %eax,%edx
8010292b:	83 e0 0f             	and    $0xf,%eax
8010292e:	c1 ea 04             	shr    $0x4,%edx
80102931:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102934:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102937:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010293a:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010293d:	89 c2                	mov    %eax,%edx
8010293f:	83 e0 0f             	and    $0xf,%eax
80102942:	c1 ea 04             	shr    $0x4,%edx
80102945:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102948:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010294b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010294e:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102951:	89 c2                	mov    %eax,%edx
80102953:	83 e0 0f             	and    $0xf,%eax
80102956:	c1 ea 04             	shr    $0x4,%edx
80102959:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010295c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010295f:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102962:	8b 75 08             	mov    0x8(%ebp),%esi
80102965:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102968:	89 06                	mov    %eax,(%esi)
8010296a:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010296d:	89 46 04             	mov    %eax,0x4(%esi)
80102970:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102973:	89 46 08             	mov    %eax,0x8(%esi)
80102976:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102979:	89 46 0c             	mov    %eax,0xc(%esi)
8010297c:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010297f:	89 46 10             	mov    %eax,0x10(%esi)
80102982:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102985:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102988:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010298f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102992:	5b                   	pop    %ebx
80102993:	5e                   	pop    %esi
80102994:	5f                   	pop    %edi
80102995:	5d                   	pop    %ebp
80102996:	c3                   	ret    
80102997:	66 90                	xchg   %ax,%ax
80102999:	66 90                	xchg   %ax,%ax
8010299b:	66 90                	xchg   %ax,%ax
8010299d:	66 90                	xchg   %ax,%ax
8010299f:	90                   	nop

801029a0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029a0:	8b 0d a8 40 11 80    	mov    0x801140a8,%ecx
801029a6:	85 c9                	test   %ecx,%ecx
801029a8:	0f 8e 85 00 00 00    	jle    80102a33 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801029ae:	55                   	push   %ebp
801029af:	89 e5                	mov    %esp,%ebp
801029b1:	57                   	push   %edi
801029b2:	56                   	push   %esi
801029b3:	53                   	push   %ebx
801029b4:	31 db                	xor    %ebx,%ebx
801029b6:	83 ec 0c             	sub    $0xc,%esp
801029b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801029c0:	a1 94 40 11 80       	mov    0x80114094,%eax
801029c5:	83 ec 08             	sub    $0x8,%esp
801029c8:	01 d8                	add    %ebx,%eax
801029ca:	83 c0 01             	add    $0x1,%eax
801029cd:	50                   	push   %eax
801029ce:	ff 35 a4 40 11 80    	pushl  0x801140a4
801029d4:	e8 f7 d6 ff ff       	call   801000d0 <bread>
801029d9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029db:	58                   	pop    %eax
801029dc:	5a                   	pop    %edx
801029dd:	ff 34 9d ac 40 11 80 	pushl  -0x7feebf54(,%ebx,4)
801029e4:	ff 35 a4 40 11 80    	pushl  0x801140a4
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029ea:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029ed:	e8 de d6 ff ff       	call   801000d0 <bread>
801029f2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029f4:	8d 47 5c             	lea    0x5c(%edi),%eax
801029f7:	83 c4 0c             	add    $0xc,%esp
801029fa:	68 00 02 00 00       	push   $0x200
801029ff:	50                   	push   %eax
80102a00:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a03:	50                   	push   %eax
80102a04:	e8 e7 21 00 00       	call   80104bf0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a09:	89 34 24             	mov    %esi,(%esp)
80102a0c:	e8 8f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a11:	89 3c 24             	mov    %edi,(%esp)
80102a14:	e8 c7 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a19:	89 34 24             	mov    %esi,(%esp)
80102a1c:	e8 bf d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a21:	83 c4 10             	add    $0x10,%esp
80102a24:	39 1d a8 40 11 80    	cmp    %ebx,0x801140a8
80102a2a:	7f 94                	jg     801029c0 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102a2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a2f:	5b                   	pop    %ebx
80102a30:	5e                   	pop    %esi
80102a31:	5f                   	pop    %edi
80102a32:	5d                   	pop    %ebp
80102a33:	f3 c3                	repz ret 
80102a35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a40:	55                   	push   %ebp
80102a41:	89 e5                	mov    %esp,%ebp
80102a43:	53                   	push   %ebx
80102a44:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a47:	ff 35 94 40 11 80    	pushl  0x80114094
80102a4d:	ff 35 a4 40 11 80    	pushl  0x801140a4
80102a53:	e8 78 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a58:	8b 0d a8 40 11 80    	mov    0x801140a8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102a5e:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102a61:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102a63:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a65:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102a68:	7e 1f                	jle    80102a89 <write_head+0x49>
80102a6a:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102a71:	31 d2                	xor    %edx,%edx
80102a73:	90                   	nop
80102a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a78:	8b 8a ac 40 11 80    	mov    -0x7feebf54(%edx),%ecx
80102a7e:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102a82:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102a85:	39 c2                	cmp    %eax,%edx
80102a87:	75 ef                	jne    80102a78 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102a89:	83 ec 0c             	sub    $0xc,%esp
80102a8c:	53                   	push   %ebx
80102a8d:	e8 0e d7 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102a92:	89 1c 24             	mov    %ebx,(%esp)
80102a95:	e8 46 d7 ff ff       	call   801001e0 <brelse>
}
80102a9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a9d:	c9                   	leave  
80102a9e:	c3                   	ret    
80102a9f:	90                   	nop

80102aa0 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102aa0:	55                   	push   %ebp
80102aa1:	89 e5                	mov    %esp,%ebp
80102aa3:	53                   	push   %ebx
80102aa4:	83 ec 2c             	sub    $0x2c,%esp
80102aa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102aaa:	68 c0 7d 10 80       	push   $0x80107dc0
80102aaf:	68 60 40 11 80       	push   $0x80114060
80102ab4:	e8 27 1e 00 00       	call   801048e0 <initlock>
  readsb(dev, &sb);
80102ab9:	58                   	pop    %eax
80102aba:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102abd:	5a                   	pop    %edx
80102abe:	50                   	push   %eax
80102abf:	53                   	push   %ebx
80102ac0:	e8 5b e9 ff ff       	call   80101420 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102ac5:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102ac8:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102acb:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102acc:	89 1d a4 40 11 80    	mov    %ebx,0x801140a4

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102ad2:	89 15 98 40 11 80    	mov    %edx,0x80114098
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102ad8:	a3 94 40 11 80       	mov    %eax,0x80114094

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102add:	5a                   	pop    %edx
80102ade:	50                   	push   %eax
80102adf:	53                   	push   %ebx
80102ae0:	e8 eb d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102ae5:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102ae8:	83 c4 10             	add    $0x10,%esp
80102aeb:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102aed:	89 0d a8 40 11 80    	mov    %ecx,0x801140a8
  for (i = 0; i < log.lh.n; i++) {
80102af3:	7e 1c                	jle    80102b11 <initlog+0x71>
80102af5:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102afc:	31 d2                	xor    %edx,%edx
80102afe:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102b00:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b04:	83 c2 04             	add    $0x4,%edx
80102b07:	89 8a a8 40 11 80    	mov    %ecx,-0x7feebf58(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b0d:	39 da                	cmp    %ebx,%edx
80102b0f:	75 ef                	jne    80102b00 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102b11:	83 ec 0c             	sub    $0xc,%esp
80102b14:	50                   	push   %eax
80102b15:	e8 c6 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b1a:	e8 81 fe ff ff       	call   801029a0 <install_trans>
  log.lh.n = 0;
80102b1f:	c7 05 a8 40 11 80 00 	movl   $0x0,0x801140a8
80102b26:	00 00 00 
  write_head(); // clear the log
80102b29:	e8 12 ff ff ff       	call   80102a40 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102b2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b31:	c9                   	leave  
80102b32:	c3                   	ret    
80102b33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b40:	55                   	push   %ebp
80102b41:	89 e5                	mov    %esp,%ebp
80102b43:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102b46:	68 60 40 11 80       	push   $0x80114060
80102b4b:	e8 f0 1e 00 00       	call   80104a40 <acquire>
80102b50:	83 c4 10             	add    $0x10,%esp
80102b53:	eb 18                	jmp    80102b6d <begin_op+0x2d>
80102b55:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b58:	83 ec 08             	sub    $0x8,%esp
80102b5b:	68 60 40 11 80       	push   $0x80114060
80102b60:	68 60 40 11 80       	push   $0x80114060
80102b65:	e8 f6 17 00 00       	call   80104360 <sleep>
80102b6a:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102b6d:	a1 a0 40 11 80       	mov    0x801140a0,%eax
80102b72:	85 c0                	test   %eax,%eax
80102b74:	75 e2                	jne    80102b58 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b76:	a1 9c 40 11 80       	mov    0x8011409c,%eax
80102b7b:	8b 15 a8 40 11 80    	mov    0x801140a8,%edx
80102b81:	83 c0 01             	add    $0x1,%eax
80102b84:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b87:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b8a:	83 fa 1e             	cmp    $0x1e,%edx
80102b8d:	7f c9                	jg     80102b58 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102b8f:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102b92:	a3 9c 40 11 80       	mov    %eax,0x8011409c
      release(&log.lock);
80102b97:	68 60 40 11 80       	push   $0x80114060
80102b9c:	e8 4f 1f 00 00       	call   80104af0 <release>
      break;
    }
  }
}
80102ba1:	83 c4 10             	add    $0x10,%esp
80102ba4:	c9                   	leave  
80102ba5:	c3                   	ret    
80102ba6:	8d 76 00             	lea    0x0(%esi),%esi
80102ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bb0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102bb0:	55                   	push   %ebp
80102bb1:	89 e5                	mov    %esp,%ebp
80102bb3:	57                   	push   %edi
80102bb4:	56                   	push   %esi
80102bb5:	53                   	push   %ebx
80102bb6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102bb9:	68 60 40 11 80       	push   $0x80114060
80102bbe:	e8 7d 1e 00 00       	call   80104a40 <acquire>
  log.outstanding -= 1;
80102bc3:	a1 9c 40 11 80       	mov    0x8011409c,%eax
  if(log.committing)
80102bc8:	8b 1d a0 40 11 80    	mov    0x801140a0,%ebx
80102bce:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102bd1:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102bd4:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102bd6:	a3 9c 40 11 80       	mov    %eax,0x8011409c
  if(log.committing)
80102bdb:	0f 85 23 01 00 00    	jne    80102d04 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102be1:	85 c0                	test   %eax,%eax
80102be3:	0f 85 f7 00 00 00    	jne    80102ce0 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102be9:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102bec:	c7 05 a0 40 11 80 01 	movl   $0x1,0x801140a0
80102bf3:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102bf6:	31 db                	xor    %ebx,%ebx
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102bf8:	68 60 40 11 80       	push   $0x80114060
80102bfd:	e8 ee 1e 00 00       	call   80104af0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c02:	8b 0d a8 40 11 80    	mov    0x801140a8,%ecx
80102c08:	83 c4 10             	add    $0x10,%esp
80102c0b:	85 c9                	test   %ecx,%ecx
80102c0d:	0f 8e 8a 00 00 00    	jle    80102c9d <end_op+0xed>
80102c13:	90                   	nop
80102c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c18:	a1 94 40 11 80       	mov    0x80114094,%eax
80102c1d:	83 ec 08             	sub    $0x8,%esp
80102c20:	01 d8                	add    %ebx,%eax
80102c22:	83 c0 01             	add    $0x1,%eax
80102c25:	50                   	push   %eax
80102c26:	ff 35 a4 40 11 80    	pushl  0x801140a4
80102c2c:	e8 9f d4 ff ff       	call   801000d0 <bread>
80102c31:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c33:	58                   	pop    %eax
80102c34:	5a                   	pop    %edx
80102c35:	ff 34 9d ac 40 11 80 	pushl  -0x7feebf54(,%ebx,4)
80102c3c:	ff 35 a4 40 11 80    	pushl  0x801140a4
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c42:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c45:	e8 86 d4 ff ff       	call   801000d0 <bread>
80102c4a:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c4c:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c4f:	83 c4 0c             	add    $0xc,%esp
80102c52:	68 00 02 00 00       	push   $0x200
80102c57:	50                   	push   %eax
80102c58:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c5b:	50                   	push   %eax
80102c5c:	e8 8f 1f 00 00       	call   80104bf0 <memmove>
    bwrite(to);  // write the log
80102c61:	89 34 24             	mov    %esi,(%esp)
80102c64:	e8 37 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c69:	89 3c 24             	mov    %edi,(%esp)
80102c6c:	e8 6f d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c71:	89 34 24             	mov    %esi,(%esp)
80102c74:	e8 67 d5 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c79:	83 c4 10             	add    $0x10,%esp
80102c7c:	3b 1d a8 40 11 80    	cmp    0x801140a8,%ebx
80102c82:	7c 94                	jl     80102c18 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102c84:	e8 b7 fd ff ff       	call   80102a40 <write_head>
    install_trans(); // Now install writes to home locations
80102c89:	e8 12 fd ff ff       	call   801029a0 <install_trans>
    log.lh.n = 0;
80102c8e:	c7 05 a8 40 11 80 00 	movl   $0x0,0x801140a8
80102c95:	00 00 00 
    write_head();    // Erase the transaction from the log
80102c98:	e8 a3 fd ff ff       	call   80102a40 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102c9d:	83 ec 0c             	sub    $0xc,%esp
80102ca0:	68 60 40 11 80       	push   $0x80114060
80102ca5:	e8 96 1d 00 00       	call   80104a40 <acquire>
    log.committing = 0;
    wakeup(&log);
80102caa:	c7 04 24 60 40 11 80 	movl   $0x80114060,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80102cb1:	c7 05 a0 40 11 80 00 	movl   $0x0,0x801140a0
80102cb8:	00 00 00 
    wakeup(&log);
80102cbb:	e8 d0 18 00 00       	call   80104590 <wakeup>
    release(&log.lock);
80102cc0:	c7 04 24 60 40 11 80 	movl   $0x80114060,(%esp)
80102cc7:	e8 24 1e 00 00       	call   80104af0 <release>
80102ccc:	83 c4 10             	add    $0x10,%esp
  }
}
80102ccf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cd2:	5b                   	pop    %ebx
80102cd3:	5e                   	pop    %esi
80102cd4:	5f                   	pop    %edi
80102cd5:	5d                   	pop    %ebp
80102cd6:	c3                   	ret    
80102cd7:	89 f6                	mov    %esi,%esi
80102cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80102ce0:	83 ec 0c             	sub    $0xc,%esp
80102ce3:	68 60 40 11 80       	push   $0x80114060
80102ce8:	e8 a3 18 00 00       	call   80104590 <wakeup>
  }
  release(&log.lock);
80102ced:	c7 04 24 60 40 11 80 	movl   $0x80114060,(%esp)
80102cf4:	e8 f7 1d 00 00       	call   80104af0 <release>
80102cf9:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
80102cfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cff:	5b                   	pop    %ebx
80102d00:	5e                   	pop    %esi
80102d01:	5f                   	pop    %edi
80102d02:	5d                   	pop    %ebp
80102d03:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102d04:	83 ec 0c             	sub    $0xc,%esp
80102d07:	68 c4 7d 10 80       	push   $0x80107dc4
80102d0c:	e8 5f d6 ff ff       	call   80100370 <panic>
80102d11:	eb 0d                	jmp    80102d20 <log_write>
80102d13:	90                   	nop
80102d14:	90                   	nop
80102d15:	90                   	nop
80102d16:	90                   	nop
80102d17:	90                   	nop
80102d18:	90                   	nop
80102d19:	90                   	nop
80102d1a:	90                   	nop
80102d1b:	90                   	nop
80102d1c:	90                   	nop
80102d1d:	90                   	nop
80102d1e:	90                   	nop
80102d1f:	90                   	nop

80102d20 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d20:	55                   	push   %ebp
80102d21:	89 e5                	mov    %esp,%ebp
80102d23:	53                   	push   %ebx
80102d24:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d27:	8b 15 a8 40 11 80    	mov    0x801140a8,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d30:	83 fa 1d             	cmp    $0x1d,%edx
80102d33:	0f 8f 97 00 00 00    	jg     80102dd0 <log_write+0xb0>
80102d39:	a1 98 40 11 80       	mov    0x80114098,%eax
80102d3e:	83 e8 01             	sub    $0x1,%eax
80102d41:	39 c2                	cmp    %eax,%edx
80102d43:	0f 8d 87 00 00 00    	jge    80102dd0 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d49:	a1 9c 40 11 80       	mov    0x8011409c,%eax
80102d4e:	85 c0                	test   %eax,%eax
80102d50:	0f 8e 87 00 00 00    	jle    80102ddd <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d56:	83 ec 0c             	sub    $0xc,%esp
80102d59:	68 60 40 11 80       	push   $0x80114060
80102d5e:	e8 dd 1c 00 00       	call   80104a40 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d63:	8b 15 a8 40 11 80    	mov    0x801140a8,%edx
80102d69:	83 c4 10             	add    $0x10,%esp
80102d6c:	83 fa 00             	cmp    $0x0,%edx
80102d6f:	7e 50                	jle    80102dc1 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d71:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d74:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d76:	3b 0d ac 40 11 80    	cmp    0x801140ac,%ecx
80102d7c:	75 0b                	jne    80102d89 <log_write+0x69>
80102d7e:	eb 38                	jmp    80102db8 <log_write+0x98>
80102d80:	39 0c 85 ac 40 11 80 	cmp    %ecx,-0x7feebf54(,%eax,4)
80102d87:	74 2f                	je     80102db8 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d89:	83 c0 01             	add    $0x1,%eax
80102d8c:	39 d0                	cmp    %edx,%eax
80102d8e:	75 f0                	jne    80102d80 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102d90:	89 0c 95 ac 40 11 80 	mov    %ecx,-0x7feebf54(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d97:	83 c2 01             	add    $0x1,%edx
80102d9a:	89 15 a8 40 11 80    	mov    %edx,0x801140a8
  b->flags |= B_DIRTY; // prevent eviction
80102da0:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102da3:	c7 45 08 60 40 11 80 	movl   $0x80114060,0x8(%ebp)
}
80102daa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dad:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102dae:	e9 3d 1d 00 00       	jmp    80104af0 <release>
80102db3:	90                   	nop
80102db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102db8:	89 0c 85 ac 40 11 80 	mov    %ecx,-0x7feebf54(,%eax,4)
80102dbf:	eb df                	jmp    80102da0 <log_write+0x80>
80102dc1:	8b 43 08             	mov    0x8(%ebx),%eax
80102dc4:	a3 ac 40 11 80       	mov    %eax,0x801140ac
  if (i == log.lh.n)
80102dc9:	75 d5                	jne    80102da0 <log_write+0x80>
80102dcb:	eb ca                	jmp    80102d97 <log_write+0x77>
80102dcd:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102dd0:	83 ec 0c             	sub    $0xc,%esp
80102dd3:	68 d3 7d 10 80       	push   $0x80107dd3
80102dd8:	e8 93 d5 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102ddd:	83 ec 0c             	sub    $0xc,%esp
80102de0:	68 e9 7d 10 80       	push   $0x80107de9
80102de5:	e8 86 d5 ff ff       	call   80100370 <panic>
80102dea:	66 90                	xchg   %ax,%ax
80102dec:	66 90                	xchg   %ax,%ax
80102dee:	66 90                	xchg   %ax,%ax

80102df0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102df0:	55                   	push   %ebp
80102df1:	89 e5                	mov    %esp,%ebp
80102df3:	53                   	push   %ebx
80102df4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102df7:	e8 d4 09 00 00       	call   801037d0 <cpuid>
80102dfc:	89 c3                	mov    %eax,%ebx
80102dfe:	e8 cd 09 00 00       	call   801037d0 <cpuid>
80102e03:	83 ec 04             	sub    $0x4,%esp
80102e06:	53                   	push   %ebx
80102e07:	50                   	push   %eax
80102e08:	68 04 7e 10 80       	push   $0x80107e04
80102e0d:	e8 4e d8 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e12:	e8 79 31 00 00       	call   80105f90 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e17:	e8 34 09 00 00       	call   80103750 <mycpu>
80102e1c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e1e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e23:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e2a:	e8 81 0e 00 00       	call   80103cb0 <scheduler>
80102e2f:	90                   	nop

80102e30 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102e30:	55                   	push   %ebp
80102e31:	89 e5                	mov    %esp,%ebp
80102e33:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e36:	e8 05 44 00 00       	call   80107240 <switchkvm>
  seginit();
80102e3b:	e8 00 43 00 00       	call   80107140 <seginit>
  lapicinit();
80102e40:	e8 9b f7 ff ff       	call   801025e0 <lapicinit>
  mpmain();
80102e45:	e8 a6 ff ff ff       	call   80102df0 <mpmain>
80102e4a:	66 90                	xchg   %ax,%ax
80102e4c:	66 90                	xchg   %ax,%ax
80102e4e:	66 90                	xchg   %ax,%ax

80102e50 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e50:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102e54:	83 e4 f0             	and    $0xfffffff0,%esp
80102e57:	ff 71 fc             	pushl  -0x4(%ecx)
80102e5a:	55                   	push   %ebp
80102e5b:	89 e5                	mov    %esp,%ebp
80102e5d:	53                   	push   %ebx
80102e5e:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102e5f:	bb 60 41 11 80       	mov    $0x80114160,%ebx
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e64:	83 ec 08             	sub    $0x8,%esp
80102e67:	68 00 00 40 80       	push   $0x80400000
80102e6c:	68 88 76 11 80       	push   $0x80117688
80102e71:	e8 3a f5 ff ff       	call   801023b0 <kinit1>
  kvmalloc();      // kernel page table
80102e76:	e8 65 48 00 00       	call   801076e0 <kvmalloc>
  mpinit();        // detect other processors
80102e7b:	e8 70 01 00 00       	call   80102ff0 <mpinit>
  lapicinit();     // interrupt controller
80102e80:	e8 5b f7 ff ff       	call   801025e0 <lapicinit>
  seginit();       // segment descriptors
80102e85:	e8 b6 42 00 00       	call   80107140 <seginit>
  picinit();       // disable pic
80102e8a:	e8 31 03 00 00       	call   801031c0 <picinit>
  ioapicinit();    // another interrupt controller
80102e8f:	e8 4c f3 ff ff       	call   801021e0 <ioapicinit>
  consoleinit();   // console hardware
80102e94:	e8 07 db ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80102e99:	e8 e2 33 00 00       	call   80106280 <uartinit>
  pinit();         // process table
80102e9e:	e8 3d 08 00 00       	call   801036e0 <pinit>
  tvinit();        // trap vectors
80102ea3:	e8 48 30 00 00       	call   80105ef0 <tvinit>
  binit();         // buffer cache
80102ea8:	e8 93 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102ead:	e8 9e de ff ff       	call   80100d50 <fileinit>
  ideinit();       // disk 
80102eb2:	e8 09 f1 ff ff       	call   80101fc0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102eb7:	83 c4 0c             	add    $0xc,%esp
80102eba:	68 8a 00 00 00       	push   $0x8a
80102ebf:	68 8c b4 10 80       	push   $0x8010b48c
80102ec4:	68 00 70 00 80       	push   $0x80007000
80102ec9:	e8 22 1d 00 00       	call   80104bf0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102ece:	69 05 e0 46 11 80 b0 	imul   $0xb0,0x801146e0,%eax
80102ed5:	00 00 00 
80102ed8:	83 c4 10             	add    $0x10,%esp
80102edb:	05 60 41 11 80       	add    $0x80114160,%eax
80102ee0:	39 d8                	cmp    %ebx,%eax
80102ee2:	76 6f                	jbe    80102f53 <main+0x103>
80102ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102ee8:	e8 63 08 00 00       	call   80103750 <mycpu>
80102eed:	39 d8                	cmp    %ebx,%eax
80102eef:	74 49                	je     80102f3a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102ef1:	e8 8a f5 ff ff       	call   80102480 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102ef6:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102efb:	c7 05 f8 6f 00 80 30 	movl   $0x80102e30,0x80006ff8
80102f02:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f05:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102f0c:	a0 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f0f:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102f14:	0f b6 03             	movzbl (%ebx),%eax
80102f17:	83 ec 08             	sub    $0x8,%esp
80102f1a:	68 00 70 00 00       	push   $0x7000
80102f1f:	50                   	push   %eax
80102f20:	e8 0b f8 ff ff       	call   80102730 <lapicstartap>
80102f25:	83 c4 10             	add    $0x10,%esp
80102f28:	90                   	nop
80102f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f30:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f36:	85 c0                	test   %eax,%eax
80102f38:	74 f6                	je     80102f30 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102f3a:	69 05 e0 46 11 80 b0 	imul   $0xb0,0x801146e0,%eax
80102f41:	00 00 00 
80102f44:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f4a:	05 60 41 11 80       	add    $0x80114160,%eax
80102f4f:	39 c3                	cmp    %eax,%ebx
80102f51:	72 95                	jb     80102ee8 <main+0x98>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f53:	83 ec 08             	sub    $0x8,%esp
80102f56:	68 00 00 00 8e       	push   $0x8e000000
80102f5b:	68 00 00 40 80       	push   $0x80400000
80102f60:	e8 bb f4 ff ff       	call   80102420 <kinit2>
  userinit();      // first user process
80102f65:	e8 b6 08 00 00       	call   80103820 <userinit>
  mpmain();        // finish this processor's setup
80102f6a:	e8 81 fe ff ff       	call   80102df0 <mpmain>
80102f6f:	90                   	nop

80102f70 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f70:	55                   	push   %ebp
80102f71:	89 e5                	mov    %esp,%ebp
80102f73:	57                   	push   %edi
80102f74:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f75:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f7b:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102f7c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f7f:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102f82:	39 de                	cmp    %ebx,%esi
80102f84:	73 48                	jae    80102fce <mpsearch1+0x5e>
80102f86:	8d 76 00             	lea    0x0(%esi),%esi
80102f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f90:	83 ec 04             	sub    $0x4,%esp
80102f93:	8d 7e 10             	lea    0x10(%esi),%edi
80102f96:	6a 04                	push   $0x4
80102f98:	68 18 7e 10 80       	push   $0x80107e18
80102f9d:	56                   	push   %esi
80102f9e:	e8 ed 1b 00 00       	call   80104b90 <memcmp>
80102fa3:	83 c4 10             	add    $0x10,%esp
80102fa6:	85 c0                	test   %eax,%eax
80102fa8:	75 1e                	jne    80102fc8 <mpsearch1+0x58>
80102faa:	8d 7e 10             	lea    0x10(%esi),%edi
80102fad:	89 f2                	mov    %esi,%edx
80102faf:	31 c9                	xor    %ecx,%ecx
80102fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80102fb8:	0f b6 02             	movzbl (%edx),%eax
80102fbb:	83 c2 01             	add    $0x1,%edx
80102fbe:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102fc0:	39 fa                	cmp    %edi,%edx
80102fc2:	75 f4                	jne    80102fb8 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fc4:	84 c9                	test   %cl,%cl
80102fc6:	74 10                	je     80102fd8 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102fc8:	39 fb                	cmp    %edi,%ebx
80102fca:	89 fe                	mov    %edi,%esi
80102fcc:	77 c2                	ja     80102f90 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80102fce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80102fd1:	31 c0                	xor    %eax,%eax
}
80102fd3:	5b                   	pop    %ebx
80102fd4:	5e                   	pop    %esi
80102fd5:	5f                   	pop    %edi
80102fd6:	5d                   	pop    %ebp
80102fd7:	c3                   	ret    
80102fd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fdb:	89 f0                	mov    %esi,%eax
80102fdd:	5b                   	pop    %ebx
80102fde:	5e                   	pop    %esi
80102fdf:	5f                   	pop    %edi
80102fe0:	5d                   	pop    %ebp
80102fe1:	c3                   	ret    
80102fe2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ff0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102ff0:	55                   	push   %ebp
80102ff1:	89 e5                	mov    %esp,%ebp
80102ff3:	57                   	push   %edi
80102ff4:	56                   	push   %esi
80102ff5:	53                   	push   %ebx
80102ff6:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102ff9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103000:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103007:	c1 e0 08             	shl    $0x8,%eax
8010300a:	09 d0                	or     %edx,%eax
8010300c:	c1 e0 04             	shl    $0x4,%eax
8010300f:	85 c0                	test   %eax,%eax
80103011:	75 1b                	jne    8010302e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
80103013:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010301a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103021:	c1 e0 08             	shl    $0x8,%eax
80103024:	09 d0                	or     %edx,%eax
80103026:	c1 e0 0a             	shl    $0xa,%eax
80103029:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010302e:	ba 00 04 00 00       	mov    $0x400,%edx
80103033:	e8 38 ff ff ff       	call   80102f70 <mpsearch1>
80103038:	85 c0                	test   %eax,%eax
8010303a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010303d:	0f 84 37 01 00 00    	je     8010317a <mpinit+0x18a>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103043:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103046:	8b 58 04             	mov    0x4(%eax),%ebx
80103049:	85 db                	test   %ebx,%ebx
8010304b:	0f 84 43 01 00 00    	je     80103194 <mpinit+0x1a4>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103051:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103057:	83 ec 04             	sub    $0x4,%esp
8010305a:	6a 04                	push   $0x4
8010305c:	68 1d 7e 10 80       	push   $0x80107e1d
80103061:	56                   	push   %esi
80103062:	e8 29 1b 00 00       	call   80104b90 <memcmp>
80103067:	83 c4 10             	add    $0x10,%esp
8010306a:	85 c0                	test   %eax,%eax
8010306c:	0f 85 22 01 00 00    	jne    80103194 <mpinit+0x1a4>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103072:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103079:	3c 01                	cmp    $0x1,%al
8010307b:	74 08                	je     80103085 <mpinit+0x95>
8010307d:	3c 04                	cmp    $0x4,%al
8010307f:	0f 85 0f 01 00 00    	jne    80103194 <mpinit+0x1a4>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103085:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010308c:	85 ff                	test   %edi,%edi
8010308e:	74 21                	je     801030b1 <mpinit+0xc1>
80103090:	31 d2                	xor    %edx,%edx
80103092:	31 c0                	xor    %eax,%eax
80103094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103098:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
8010309f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030a0:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801030a3:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030a5:	39 c7                	cmp    %eax,%edi
801030a7:	75 ef                	jne    80103098 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801030a9:	84 d2                	test   %dl,%dl
801030ab:	0f 85 e3 00 00 00    	jne    80103194 <mpinit+0x1a4>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801030b1:	85 f6                	test   %esi,%esi
801030b3:	0f 84 db 00 00 00    	je     80103194 <mpinit+0x1a4>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801030b9:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801030bf:	a3 5c 40 11 80       	mov    %eax,0x8011405c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030c4:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801030cb:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
801030d1:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030d6:	01 d6                	add    %edx,%esi
801030d8:	90                   	nop
801030d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030e0:	39 c6                	cmp    %eax,%esi
801030e2:	76 23                	jbe    80103107 <mpinit+0x117>
801030e4:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
801030e7:	80 fa 04             	cmp    $0x4,%dl
801030ea:	0f 87 c0 00 00 00    	ja     801031b0 <mpinit+0x1c0>
801030f0:	ff 24 95 5c 7e 10 80 	jmp    *-0x7fef81a4(,%edx,4)
801030f7:	89 f6                	mov    %esi,%esi
801030f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103100:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103103:	39 c6                	cmp    %eax,%esi
80103105:	77 dd                	ja     801030e4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103107:	85 db                	test   %ebx,%ebx
80103109:	0f 84 92 00 00 00    	je     801031a1 <mpinit+0x1b1>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010310f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103112:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103116:	74 15                	je     8010312d <mpinit+0x13d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103118:	ba 22 00 00 00       	mov    $0x22,%edx
8010311d:	b8 70 00 00 00       	mov    $0x70,%eax
80103122:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103123:	ba 23 00 00 00       	mov    $0x23,%edx
80103128:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103129:	83 c8 01             	or     $0x1,%eax
8010312c:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010312d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103130:	5b                   	pop    %ebx
80103131:	5e                   	pop    %esi
80103132:	5f                   	pop    %edi
80103133:	5d                   	pop    %ebp
80103134:	c3                   	ret    
80103135:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103138:	8b 0d e0 46 11 80    	mov    0x801146e0,%ecx
8010313e:	83 f9 07             	cmp    $0x7,%ecx
80103141:	7f 19                	jg     8010315c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103143:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103147:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010314d:	83 c1 01             	add    $0x1,%ecx
80103150:	89 0d e0 46 11 80    	mov    %ecx,0x801146e0
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103156:	88 97 60 41 11 80    	mov    %dl,-0x7feebea0(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010315c:	83 c0 14             	add    $0x14,%eax
      continue;
8010315f:	e9 7c ff ff ff       	jmp    801030e0 <mpinit+0xf0>
80103164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103168:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010316c:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
8010316f:	88 15 40 41 11 80    	mov    %dl,0x80114140
      p += sizeof(struct mpioapic);
      continue;
80103175:	e9 66 ff ff ff       	jmp    801030e0 <mpinit+0xf0>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010317a:	ba 00 00 01 00       	mov    $0x10000,%edx
8010317f:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103184:	e8 e7 fd ff ff       	call   80102f70 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103189:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010318b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010318e:	0f 85 af fe ff ff    	jne    80103043 <mpinit+0x53>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
80103194:	83 ec 0c             	sub    $0xc,%esp
80103197:	68 22 7e 10 80       	push   $0x80107e22
8010319c:	e8 cf d1 ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
801031a1:	83 ec 0c             	sub    $0xc,%esp
801031a4:	68 3c 7e 10 80       	push   $0x80107e3c
801031a9:	e8 c2 d1 ff ff       	call   80100370 <panic>
801031ae:	66 90                	xchg   %ax,%ax
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
801031b0:	31 db                	xor    %ebx,%ebx
801031b2:	e9 30 ff ff ff       	jmp    801030e7 <mpinit+0xf7>
801031b7:	66 90                	xchg   %ax,%ax
801031b9:	66 90                	xchg   %ax,%ax
801031bb:	66 90                	xchg   %ax,%ax
801031bd:	66 90                	xchg   %ax,%ax
801031bf:	90                   	nop

801031c0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801031c0:	55                   	push   %ebp
801031c1:	ba 21 00 00 00       	mov    $0x21,%edx
801031c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801031cb:	89 e5                	mov    %esp,%ebp
801031cd:	ee                   	out    %al,(%dx)
801031ce:	ba a1 00 00 00       	mov    $0xa1,%edx
801031d3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801031d4:	5d                   	pop    %ebp
801031d5:	c3                   	ret    
801031d6:	66 90                	xchg   %ax,%ax
801031d8:	66 90                	xchg   %ax,%ax
801031da:	66 90                	xchg   %ax,%ax
801031dc:	66 90                	xchg   %ax,%ax
801031de:	66 90                	xchg   %ax,%ax

801031e0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801031e0:	55                   	push   %ebp
801031e1:	89 e5                	mov    %esp,%ebp
801031e3:	57                   	push   %edi
801031e4:	56                   	push   %esi
801031e5:	53                   	push   %ebx
801031e6:	83 ec 0c             	sub    $0xc,%esp
801031e9:	8b 75 08             	mov    0x8(%ebp),%esi
801031ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801031ef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801031f5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801031fb:	e8 70 db ff ff       	call   80100d70 <filealloc>
80103200:	85 c0                	test   %eax,%eax
80103202:	89 06                	mov    %eax,(%esi)
80103204:	0f 84 a8 00 00 00    	je     801032b2 <pipealloc+0xd2>
8010320a:	e8 61 db ff ff       	call   80100d70 <filealloc>
8010320f:	85 c0                	test   %eax,%eax
80103211:	89 03                	mov    %eax,(%ebx)
80103213:	0f 84 87 00 00 00    	je     801032a0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103219:	e8 62 f2 ff ff       	call   80102480 <kalloc>
8010321e:	85 c0                	test   %eax,%eax
80103220:	89 c7                	mov    %eax,%edi
80103222:	0f 84 b0 00 00 00    	je     801032d8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103228:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
8010322b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103232:	00 00 00 
  p->writeopen = 1;
80103235:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010323c:	00 00 00 
  p->nwrite = 0;
8010323f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103246:	00 00 00 
  p->nread = 0;
80103249:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103250:	00 00 00 
  initlock(&p->lock, "pipe");
80103253:	68 70 7e 10 80       	push   $0x80107e70
80103258:	50                   	push   %eax
80103259:	e8 82 16 00 00       	call   801048e0 <initlock>
  (*f0)->type = FD_PIPE;
8010325e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103260:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
80103263:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103269:	8b 06                	mov    (%esi),%eax
8010326b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010326f:	8b 06                	mov    (%esi),%eax
80103271:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103275:	8b 06                	mov    (%esi),%eax
80103277:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010327a:	8b 03                	mov    (%ebx),%eax
8010327c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103282:	8b 03                	mov    (%ebx),%eax
80103284:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103288:	8b 03                	mov    (%ebx),%eax
8010328a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010328e:	8b 03                	mov    (%ebx),%eax
80103290:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103293:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103296:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103298:	5b                   	pop    %ebx
80103299:	5e                   	pop    %esi
8010329a:	5f                   	pop    %edi
8010329b:	5d                   	pop    %ebp
8010329c:	c3                   	ret    
8010329d:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032a0:	8b 06                	mov    (%esi),%eax
801032a2:	85 c0                	test   %eax,%eax
801032a4:	74 1e                	je     801032c4 <pipealloc+0xe4>
    fileclose(*f0);
801032a6:	83 ec 0c             	sub    $0xc,%esp
801032a9:	50                   	push   %eax
801032aa:	e8 81 db ff ff       	call   80100e30 <fileclose>
801032af:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801032b2:	8b 03                	mov    (%ebx),%eax
801032b4:	85 c0                	test   %eax,%eax
801032b6:	74 0c                	je     801032c4 <pipealloc+0xe4>
    fileclose(*f1);
801032b8:	83 ec 0c             	sub    $0xc,%esp
801032bb:	50                   	push   %eax
801032bc:	e8 6f db ff ff       	call   80100e30 <fileclose>
801032c1:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801032c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
801032c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032cc:	5b                   	pop    %ebx
801032cd:	5e                   	pop    %esi
801032ce:	5f                   	pop    %edi
801032cf:	5d                   	pop    %ebp
801032d0:	c3                   	ret    
801032d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032d8:	8b 06                	mov    (%esi),%eax
801032da:	85 c0                	test   %eax,%eax
801032dc:	75 c8                	jne    801032a6 <pipealloc+0xc6>
801032de:	eb d2                	jmp    801032b2 <pipealloc+0xd2>

801032e0 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
801032e0:	55                   	push   %ebp
801032e1:	89 e5                	mov    %esp,%ebp
801032e3:	56                   	push   %esi
801032e4:	53                   	push   %ebx
801032e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801032e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801032eb:	83 ec 0c             	sub    $0xc,%esp
801032ee:	53                   	push   %ebx
801032ef:	e8 4c 17 00 00       	call   80104a40 <acquire>
  if(writable){
801032f4:	83 c4 10             	add    $0x10,%esp
801032f7:	85 f6                	test   %esi,%esi
801032f9:	74 45                	je     80103340 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801032fb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103301:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103304:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010330b:	00 00 00 
    wakeup(&p->nread);
8010330e:	50                   	push   %eax
8010330f:	e8 7c 12 00 00       	call   80104590 <wakeup>
80103314:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103317:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010331d:	85 d2                	test   %edx,%edx
8010331f:	75 0a                	jne    8010332b <pipeclose+0x4b>
80103321:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103327:	85 c0                	test   %eax,%eax
80103329:	74 35                	je     80103360 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010332b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010332e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103331:	5b                   	pop    %ebx
80103332:	5e                   	pop    %esi
80103333:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103334:	e9 b7 17 00 00       	jmp    80104af0 <release>
80103339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103340:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103346:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
80103349:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103350:	00 00 00 
    wakeup(&p->nwrite);
80103353:	50                   	push   %eax
80103354:	e8 37 12 00 00       	call   80104590 <wakeup>
80103359:	83 c4 10             	add    $0x10,%esp
8010335c:	eb b9                	jmp    80103317 <pipeclose+0x37>
8010335e:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103360:	83 ec 0c             	sub    $0xc,%esp
80103363:	53                   	push   %ebx
80103364:	e8 87 17 00 00       	call   80104af0 <release>
    kfree((char*)p);
80103369:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010336c:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
8010336f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103372:	5b                   	pop    %ebx
80103373:	5e                   	pop    %esi
80103374:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103375:	e9 56 ef ff ff       	jmp    801022d0 <kfree>
8010337a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103380 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103380:	55                   	push   %ebp
80103381:	89 e5                	mov    %esp,%ebp
80103383:	57                   	push   %edi
80103384:	56                   	push   %esi
80103385:	53                   	push   %ebx
80103386:	83 ec 28             	sub    $0x28,%esp
80103389:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010338c:	53                   	push   %ebx
8010338d:	e8 ae 16 00 00       	call   80104a40 <acquire>
  for(i = 0; i < n; i++){
80103392:	8b 45 10             	mov    0x10(%ebp),%eax
80103395:	83 c4 10             	add    $0x10,%esp
80103398:	85 c0                	test   %eax,%eax
8010339a:	0f 8e b9 00 00 00    	jle    80103459 <pipewrite+0xd9>
801033a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801033a3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801033a9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801033af:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801033b5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801033b8:	03 4d 10             	add    0x10(%ebp),%ecx
801033bb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033be:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801033c4:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801033ca:	39 d0                	cmp    %edx,%eax
801033cc:	74 38                	je     80103406 <pipewrite+0x86>
801033ce:	eb 59                	jmp    80103429 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
801033d0:	e8 1b 04 00 00       	call   801037f0 <myproc>
801033d5:	8b 48 24             	mov    0x24(%eax),%ecx
801033d8:	85 c9                	test   %ecx,%ecx
801033da:	75 34                	jne    80103410 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801033dc:	83 ec 0c             	sub    $0xc,%esp
801033df:	57                   	push   %edi
801033e0:	e8 ab 11 00 00       	call   80104590 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801033e5:	58                   	pop    %eax
801033e6:	5a                   	pop    %edx
801033e7:	53                   	push   %ebx
801033e8:	56                   	push   %esi
801033e9:	e8 72 0f 00 00       	call   80104360 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033ee:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801033f4:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801033fa:	83 c4 10             	add    $0x10,%esp
801033fd:	05 00 02 00 00       	add    $0x200,%eax
80103402:	39 c2                	cmp    %eax,%edx
80103404:	75 2a                	jne    80103430 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
80103406:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010340c:	85 c0                	test   %eax,%eax
8010340e:	75 c0                	jne    801033d0 <pipewrite+0x50>
        release(&p->lock);
80103410:	83 ec 0c             	sub    $0xc,%esp
80103413:	53                   	push   %ebx
80103414:	e8 d7 16 00 00       	call   80104af0 <release>
        return -1;
80103419:	83 c4 10             	add    $0x10,%esp
8010341c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103421:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103424:	5b                   	pop    %ebx
80103425:	5e                   	pop    %esi
80103426:	5f                   	pop    %edi
80103427:	5d                   	pop    %ebp
80103428:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103429:	89 c2                	mov    %eax,%edx
8010342b:	90                   	nop
8010342c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103430:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103433:	8d 42 01             	lea    0x1(%edx),%eax
80103436:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010343a:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103440:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103446:	0f b6 09             	movzbl (%ecx),%ecx
80103449:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
8010344d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103450:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
80103453:	0f 85 65 ff ff ff    	jne    801033be <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103459:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010345f:	83 ec 0c             	sub    $0xc,%esp
80103462:	50                   	push   %eax
80103463:	e8 28 11 00 00       	call   80104590 <wakeup>
  release(&p->lock);
80103468:	89 1c 24             	mov    %ebx,(%esp)
8010346b:	e8 80 16 00 00       	call   80104af0 <release>
  return n;
80103470:	83 c4 10             	add    $0x10,%esp
80103473:	8b 45 10             	mov    0x10(%ebp),%eax
80103476:	eb a9                	jmp    80103421 <pipewrite+0xa1>
80103478:	90                   	nop
80103479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103480 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103480:	55                   	push   %ebp
80103481:	89 e5                	mov    %esp,%ebp
80103483:	57                   	push   %edi
80103484:	56                   	push   %esi
80103485:	53                   	push   %ebx
80103486:	83 ec 18             	sub    $0x18,%esp
80103489:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010348c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010348f:	53                   	push   %ebx
80103490:	e8 ab 15 00 00       	call   80104a40 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103495:	83 c4 10             	add    $0x10,%esp
80103498:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010349e:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
801034a4:	75 6a                	jne    80103510 <piperead+0x90>
801034a6:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
801034ac:	85 f6                	test   %esi,%esi
801034ae:	0f 84 cc 00 00 00    	je     80103580 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801034b4:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
801034ba:	eb 2d                	jmp    801034e9 <piperead+0x69>
801034bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034c0:	83 ec 08             	sub    $0x8,%esp
801034c3:	53                   	push   %ebx
801034c4:	56                   	push   %esi
801034c5:	e8 96 0e 00 00       	call   80104360 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801034ca:	83 c4 10             	add    $0x10,%esp
801034cd:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801034d3:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
801034d9:	75 35                	jne    80103510 <piperead+0x90>
801034db:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
801034e1:	85 d2                	test   %edx,%edx
801034e3:	0f 84 97 00 00 00    	je     80103580 <piperead+0x100>
    if(myproc()->killed){
801034e9:	e8 02 03 00 00       	call   801037f0 <myproc>
801034ee:	8b 48 24             	mov    0x24(%eax),%ecx
801034f1:	85 c9                	test   %ecx,%ecx
801034f3:	74 cb                	je     801034c0 <piperead+0x40>
      release(&p->lock);
801034f5:	83 ec 0c             	sub    $0xc,%esp
801034f8:	53                   	push   %ebx
801034f9:	e8 f2 15 00 00       	call   80104af0 <release>
      return -1;
801034fe:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103501:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
80103504:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103509:	5b                   	pop    %ebx
8010350a:	5e                   	pop    %esi
8010350b:	5f                   	pop    %edi
8010350c:	5d                   	pop    %ebp
8010350d:	c3                   	ret    
8010350e:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103510:	8b 45 10             	mov    0x10(%ebp),%eax
80103513:	85 c0                	test   %eax,%eax
80103515:	7e 69                	jle    80103580 <piperead+0x100>
    if(p->nread == p->nwrite)
80103517:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010351d:	31 c9                	xor    %ecx,%ecx
8010351f:	eb 15                	jmp    80103536 <piperead+0xb6>
80103521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103528:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010352e:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80103534:	74 5a                	je     80103590 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103536:	8d 70 01             	lea    0x1(%eax),%esi
80103539:	25 ff 01 00 00       	and    $0x1ff,%eax
8010353e:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
80103544:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
80103549:	88 04 0f             	mov    %al,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010354c:	83 c1 01             	add    $0x1,%ecx
8010354f:	39 4d 10             	cmp    %ecx,0x10(%ebp)
80103552:	75 d4                	jne    80103528 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103554:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010355a:	83 ec 0c             	sub    $0xc,%esp
8010355d:	50                   	push   %eax
8010355e:	e8 2d 10 00 00       	call   80104590 <wakeup>
  release(&p->lock);
80103563:	89 1c 24             	mov    %ebx,(%esp)
80103566:	e8 85 15 00 00       	call   80104af0 <release>
  return i;
8010356b:	8b 45 10             	mov    0x10(%ebp),%eax
8010356e:	83 c4 10             	add    $0x10,%esp
}
80103571:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103574:	5b                   	pop    %ebx
80103575:	5e                   	pop    %esi
80103576:	5f                   	pop    %edi
80103577:	5d                   	pop    %ebp
80103578:	c3                   	ret    
80103579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103580:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
80103587:	eb cb                	jmp    80103554 <piperead+0xd4>
80103589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103590:	89 4d 10             	mov    %ecx,0x10(%ebp)
80103593:	eb bf                	jmp    80103554 <piperead+0xd4>
80103595:	66 90                	xchg   %ax,%ax
80103597:	66 90                	xchg   %ax,%ax
80103599:	66 90                	xchg   %ax,%ax
8010359b:	66 90                	xchg   %ax,%ax
8010359d:	66 90                	xchg   %ax,%ax
8010359f:	90                   	nop

801035a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc()
{
801035a0:	55                   	push   %ebp
801035a1:	89 e5                	mov    %esp,%ebp
801035a3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801035a4:	bb 34 47 11 80       	mov    $0x80114734,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc()
{
801035a9:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801035ac:	68 00 47 11 80       	push   $0x80114700
801035b1:	e8 8a 14 00 00       	call   80104a40 <acquire>
801035b6:	83 c4 10             	add    $0x10,%esp
801035b9:	eb 17                	jmp    801035d2 <allocproc+0x32>
801035bb:	90                   	nop
801035bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801035c0:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
801035c6:	81 fb 34 6e 11 80    	cmp    $0x80116e34,%ebx
801035cc:	0f 84 96 00 00 00    	je     80103668 <allocproc+0xc8>
    //  p->syscall_count = 0;
    if(p->state == UNUSED)
801035d2:	8b 43 0c             	mov    0xc(%ebx),%eax
801035d5:	85 c0                	test   %eax,%eax
801035d7:	75 e7                	jne    801035c0 <allocproc+0x20>
  return 0;

found:
  p->syscall_count = 0; //LAB-1
  p->state = EMBRYO;
  p->pid = nextpid++;
801035d9:	a1 14 b0 10 80       	mov    0x8010b014,%eax

  release(&ptable.lock);
801035de:	83 ec 0c             	sub    $0xc,%esp

  release(&ptable.lock);
  return 0;

found:
  p->syscall_count = 0; //LAB-1
801035e1:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  p->state = EMBRYO;
  p->pid = nextpid++;

  release(&ptable.lock);
801035e8:	68 00 47 11 80       	push   $0x80114700
  release(&ptable.lock);
  return 0;

found:
  p->syscall_count = 0; //LAB-1
  p->state = EMBRYO;
801035ed:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801035f4:	8d 50 01             	lea    0x1(%eax),%edx
801035f7:	89 43 10             	mov    %eax,0x10(%ebx)
801035fa:	89 15 14 b0 10 80    	mov    %edx,0x8010b014

  release(&ptable.lock);
80103600:	e8 eb 14 00 00       	call   80104af0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103605:	e8 76 ee ff ff       	call   80102480 <kalloc>
8010360a:	83 c4 10             	add    $0x10,%esp
8010360d:	85 c0                	test   %eax,%eax
8010360f:	89 43 08             	mov    %eax,0x8(%ebx)
80103612:	74 6b                	je     8010367f <allocproc+0xdf>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103614:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010361a:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
8010361d:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103622:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103625:	c7 40 14 d7 5e 10 80 	movl   $0x80105ed7,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010362c:	6a 14                	push   $0x14
8010362e:	6a 00                	push   $0x0
80103630:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
80103631:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103634:	e8 07 15 00 00       	call   80104b40 <memset>
  p->context->eip = (uint)forkret;
80103639:	8b 43 1c             	mov    0x1c(%ebx),%eax
  p->pass = 0;
  p->thread_indictor = 0; //LAB-3
  return p;
8010363c:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
8010363f:	c7 40 10 90 36 10 80 	movl   $0x80103690,0x10(%eax)
  p->pass = 0;
80103646:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
8010364d:	00 00 00 
  p->thread_indictor = 0; //LAB-3
  return p;
80103650:	89 d8                	mov    %ebx,%eax
  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
  p->pass = 0;
  p->thread_indictor = 0; //LAB-3
80103652:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
80103659:	00 00 00 
  return p;
}
8010365c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010365f:	c9                   	leave  
80103660:	c3                   	ret    
80103661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    //  p->syscall_count = 0;
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103668:	83 ec 0c             	sub    $0xc,%esp
8010366b:	68 00 47 11 80       	push   $0x80114700
80103670:	e8 7b 14 00 00       	call   80104af0 <release>
  return 0;
80103675:	83 c4 10             	add    $0x10,%esp
80103678:	31 c0                	xor    %eax,%eax
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
  p->pass = 0;
  p->thread_indictor = 0; //LAB-3
  return p;
}
8010367a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010367d:	c9                   	leave  
8010367e:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
8010367f:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103686:	eb d4                	jmp    8010365c <allocproc+0xbc>
80103688:	90                   	nop
80103689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103690 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103696:	68 00 47 11 80       	push   $0x80114700
8010369b:	e8 50 14 00 00       	call   80104af0 <release>

  if (first) {
801036a0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801036a5:	83 c4 10             	add    $0x10,%esp
801036a8:	85 c0                	test   %eax,%eax
801036aa:	75 04                	jne    801036b0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801036ac:	c9                   	leave  
801036ad:	c3                   	ret    
801036ae:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
801036b0:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
801036b3:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801036ba:	00 00 00 
    iinit(ROOTDEV);
801036bd:	6a 01                	push   $0x1
801036bf:	e8 9c dd ff ff       	call   80101460 <iinit>
    initlog(ROOTDEV);
801036c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801036cb:	e8 d0 f3 ff ff       	call   80102aa0 <initlog>
801036d0:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
801036d3:	c9                   	leave  
801036d4:	c3                   	ret    
801036d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036e0 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801036e6:	68 75 7e 10 80       	push   $0x80107e75
801036eb:	68 00 47 11 80       	push   $0x80114700
801036f0:	e8 eb 11 00 00       	call   801048e0 <initlock>
}
801036f5:	83 c4 10             	add    $0x10,%esp
801036f8:	c9                   	leave  
801036f9:	c3                   	ret    
801036fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103700 <genrand64_int64>:

// NEED TO MAKE SURE TO HAVE A BOUNDED Region between 0 to max
long genrand64_int64(long max) {
80103700:	55                   	push   %ebp
    // max <= RAND_MAX < ULONG_MAX, so this is okay.
  unsigned long  bins = (unsigned long) max + 1; //number of bins
  unsigned long  num_rand = (unsigned long) RAND_MAX + 1;
  unsigned long  bin_size = num_rand / bins;
80103701:	31 d2                	xor    %edx,%edx
{
  initlock(&ptable.lock, "ptable");
}

// NEED TO MAKE SURE TO HAVE A BOUNDED Region between 0 to max
long genrand64_int64(long max) {
80103703:	89 e5                	mov    %esp,%ebp
80103705:	57                   	push   %edi
80103706:	56                   	push   %esi
80103707:	53                   	push   %ebx
    // max <= RAND_MAX < ULONG_MAX, so this is okay.
  unsigned long  bins = (unsigned long) max + 1; //number of bins
  unsigned long  num_rand = (unsigned long) RAND_MAX + 1;
  unsigned long  bin_size = num_rand / bins;
80103708:	bb 00 00 00 80       	mov    $0x80000000,%ebx
{
  initlock(&ptable.lock, "ptable");
}

// NEED TO MAKE SURE TO HAVE A BOUNDED Region between 0 to max
long genrand64_int64(long max) {
8010370d:	83 ec 0c             	sub    $0xc,%esp
    // max <= RAND_MAX < ULONG_MAX, so this is okay.
  unsigned long  bins = (unsigned long) max + 1; //number of bins
80103710:	8b 45 08             	mov    0x8(%ebp),%eax
80103713:	8d 48 01             	lea    0x1(%eax),%ecx
  unsigned long  num_rand = (unsigned long) RAND_MAX + 1;
  unsigned long  bin_size = num_rand / bins;
80103716:	89 d8                	mov    %ebx,%eax
80103718:	f7 f1                	div    %ecx
8010371a:	89 d7                	mov    %edx,%edi
8010371c:	89 c6                	mov    %eax,%esi
8010371e:	29 fb                	sub    %edi,%ebx
  unsigned long  defect   = num_rand % bins;

  long x;

   x = genrand();
80103720:	e8 1b 37 00 00       	call   80106e40 <genrand>
80103725:	89 da                	mov    %ebx,%edx
80103727:	89 f6                	mov    %esi,%esi
80103729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  // This is carefully written not to overflow
  while (num_rand - defect <= (unsigned long)x);
80103730:	39 c2                	cmp    %eax,%edx
80103732:	76 fc                	jbe    80103730 <genrand64_int64+0x30>
  {
      x = genrand();
80103734:	e8 07 37 00 00       	call   80106e40 <genrand>
  }

  // Truncated division is intentional
  return x/bin_size;
}
80103739:	83 c4 0c             	add    $0xc,%esp
  {
      x = genrand();
  }

  // Truncated division is intentional
  return x/bin_size;
8010373c:	31 d2                	xor    %edx,%edx
}
8010373e:	5b                   	pop    %ebx
  {
      x = genrand();
  }

  // Truncated division is intentional
  return x/bin_size;
8010373f:	f7 f6                	div    %esi
}
80103741:	5e                   	pop    %esi
80103742:	5f                   	pop    %edi
80103743:	5d                   	pop    %ebp
80103744:	c3                   	ret    
80103745:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103750 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	56                   	push   %esi
80103754:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103755:	9c                   	pushf  
80103756:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
80103757:	f6 c4 02             	test   $0x2,%ah
8010375a:	75 5b                	jne    801037b7 <mycpu+0x67>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
8010375c:	e8 7f ef ff ff       	call   801026e0 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103761:	8b 35 e0 46 11 80    	mov    0x801146e0,%esi
80103767:	85 f6                	test   %esi,%esi
80103769:	7e 3f                	jle    801037aa <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010376b:	0f b6 15 60 41 11 80 	movzbl 0x80114160,%edx
80103772:	39 d0                	cmp    %edx,%eax
80103774:	74 30                	je     801037a6 <mycpu+0x56>
80103776:	b9 10 42 11 80       	mov    $0x80114210,%ecx
8010377b:	31 d2                	xor    %edx,%edx
8010377d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103780:	83 c2 01             	add    $0x1,%edx
80103783:	39 f2                	cmp    %esi,%edx
80103785:	74 23                	je     801037aa <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103787:	0f b6 19             	movzbl (%ecx),%ebx
8010378a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103790:	39 d8                	cmp    %ebx,%eax
80103792:	75 ec                	jne    80103780 <mycpu+0x30>
      return &cpus[i];
80103794:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
8010379a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010379d:	5b                   	pop    %ebx
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
8010379e:	05 60 41 11 80       	add    $0x80114160,%eax
  }
  panic("unknown apicid\n");
}
801037a3:	5e                   	pop    %esi
801037a4:	5d                   	pop    %ebp
801037a5:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801037a6:	31 d2                	xor    %edx,%edx
801037a8:	eb ea                	jmp    80103794 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
801037aa:	83 ec 0c             	sub    $0xc,%esp
801037ad:	68 7c 7e 10 80       	push   $0x80107e7c
801037b2:	e8 b9 cb ff ff       	call   80100370 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
801037b7:	83 ec 0c             	sub    $0xc,%esp
801037ba:	68 64 80 10 80       	push   $0x80108064
801037bf:	e8 ac cb ff ff       	call   80100370 <panic>
801037c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801037ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801037d0 <cpuid>:
  return x/bin_size;
}

// Must be called with interrupts disabled
int
cpuid() {
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801037d6:	e8 75 ff ff ff       	call   80103750 <mycpu>
801037db:	2d 60 41 11 80       	sub    $0x80114160,%eax
}
801037e0:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
801037e1:	c1 f8 04             	sar    $0x4,%eax
801037e4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801037ea:	c3                   	ret    
801037eb:	90                   	nop
801037ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801037f0 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
801037f0:	55                   	push   %ebp
801037f1:	89 e5                	mov    %esp,%ebp
801037f3:	53                   	push   %ebx
801037f4:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
801037f7:	e8 64 11 00 00       	call   80104960 <pushcli>
  c = mycpu();
801037fc:	e8 4f ff ff ff       	call   80103750 <mycpu>
  p = c->proc;
80103801:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103807:	e8 94 11 00 00       	call   801049a0 <popcli>
  return p;
}
8010380c:	83 c4 04             	add    $0x4,%esp
8010380f:	89 d8                	mov    %ebx,%eax
80103811:	5b                   	pop    %ebx
80103812:	5d                   	pop    %ebp
80103813:	c3                   	ret    
80103814:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010381a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103820 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	53                   	push   %ebx
80103824:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  p = allocproc();
80103827:	e8 74 fd ff ff       	call   801035a0 <allocproc>
8010382c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010382e:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103833:	e8 28 3e 00 00       	call   80107660 <setupkvm>
80103838:	85 c0                	test   %eax,%eax
8010383a:	89 43 04             	mov    %eax,0x4(%ebx)
8010383d:	0f 84 bd 00 00 00    	je     80103900 <userinit+0xe0>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103843:	83 ec 04             	sub    $0x4,%esp
80103846:	68 2c 00 00 00       	push   $0x2c
8010384b:	68 60 b4 10 80       	push   $0x8010b460
80103850:	50                   	push   %eax
80103851:	e8 1a 3b 00 00       	call   80107370 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
80103856:	83 c4 0c             	add    $0xc,%esp
  p = allocproc();
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
80103859:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010385f:	6a 4c                	push   $0x4c
80103861:	6a 00                	push   $0x0
80103863:	ff 73 18             	pushl  0x18(%ebx)
80103866:	e8 d5 12 00 00       	call   80104b40 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010386b:	8b 43 18             	mov    0x18(%ebx),%eax
8010386e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103873:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103878:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010387b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010387f:	8b 43 18             	mov    0x18(%ebx),%eax
80103882:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103886:	8b 43 18             	mov    0x18(%ebx),%eax
80103889:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010388d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103891:	8b 43 18             	mov    0x18(%ebx),%eax
80103894:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103898:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010389c:	8b 43 18             	mov    0x18(%ebx),%eax
8010389f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801038a6:	8b 43 18             	mov    0x18(%ebx),%eax
801038a9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801038b0:	8b 43 18             	mov    0x18(%ebx),%eax
801038b3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801038ba:	8d 43 6c             	lea    0x6c(%ebx),%eax
801038bd:	6a 10                	push   $0x10
801038bf:	68 a5 7e 10 80       	push   $0x80107ea5
801038c4:	50                   	push   %eax
801038c5:	e8 76 14 00 00       	call   80104d40 <safestrcpy>
  p->cwd = namei("/");
801038ca:	c7 04 24 ae 7e 10 80 	movl   $0x80107eae,(%esp)
801038d1:	e8 da e5 ff ff       	call   80101eb0 <namei>
801038d6:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
801038d9:	c7 04 24 00 47 11 80 	movl   $0x80114700,(%esp)
801038e0:	e8 5b 11 00 00       	call   80104a40 <acquire>
  p->state = RUNNABLE;
801038e5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801038ec:	c7 04 24 00 47 11 80 	movl   $0x80114700,(%esp)
801038f3:	e8 f8 11 00 00       	call   80104af0 <release>
}
801038f8:	83 c4 10             	add    $0x10,%esp
801038fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038fe:	c9                   	leave  
801038ff:	c3                   	ret    
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  p = allocproc();
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103900:	83 ec 0c             	sub    $0xc,%esp
80103903:	68 8c 7e 10 80       	push   $0x80107e8c
80103908:	e8 63 ca ff ff       	call   80100370 <panic>
8010390d:	8d 76 00             	lea    0x0(%esi),%esi

80103910 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	56                   	push   %esi
80103914:	53                   	push   %ebx
80103915:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103918:	e8 43 10 00 00       	call   80104960 <pushcli>
  c = mycpu();
8010391d:	e8 2e fe ff ff       	call   80103750 <mycpu>
  p = c->proc;
80103922:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103928:	e8 73 10 00 00       	call   801049a0 <popcli>
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
8010392d:	83 fe 00             	cmp    $0x0,%esi
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
80103930:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103932:	7e 34                	jle    80103968 <growproc+0x58>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103934:	83 ec 04             	sub    $0x4,%esp
80103937:	01 c6                	add    %eax,%esi
80103939:	56                   	push   %esi
8010393a:	50                   	push   %eax
8010393b:	ff 73 04             	pushl  0x4(%ebx)
8010393e:	e8 6d 3b 00 00       	call   801074b0 <allocuvm>
80103943:	83 c4 10             	add    $0x10,%esp
80103946:	85 c0                	test   %eax,%eax
80103948:	74 36                	je     80103980 <growproc+0x70>
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
8010394a:	83 ec 0c             	sub    $0xc,%esp
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
8010394d:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010394f:	53                   	push   %ebx
80103950:	e8 0b 39 00 00       	call   80107260 <switchuvm>
  return 0;
80103955:	83 c4 10             	add    $0x10,%esp
80103958:	31 c0                	xor    %eax,%eax
}
8010395a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010395d:	5b                   	pop    %ebx
8010395e:	5e                   	pop    %esi
8010395f:	5d                   	pop    %ebp
80103960:	c3                   	ret    
80103961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103968:	74 e0                	je     8010394a <growproc+0x3a>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010396a:	83 ec 04             	sub    $0x4,%esp
8010396d:	01 c6                	add    %eax,%esi
8010396f:	56                   	push   %esi
80103970:	50                   	push   %eax
80103971:	ff 73 04             	pushl  0x4(%ebx)
80103974:	e8 37 3c 00 00       	call   801075b0 <deallocuvm>
80103979:	83 c4 10             	add    $0x10,%esp
8010397c:	85 c0                	test   %eax,%eax
8010397e:	75 ca                	jne    8010394a <growproc+0x3a>
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
80103980:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103985:	eb d3                	jmp    8010395a <growproc+0x4a>
80103987:	89 f6                	mov    %esi,%esi
80103989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103990 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	57                   	push   %edi
80103994:	56                   	push   %esi
80103995:	53                   	push   %ebx
80103996:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103999:	e8 c2 0f 00 00       	call   80104960 <pushcli>
  c = mycpu();
8010399e:	e8 ad fd ff ff       	call   80103750 <mycpu>
  p = c->proc;
801039a3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039a9:	e8 f2 0f 00 00       	call   801049a0 <popcli>
  struct proc *np;
  struct proc *p;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
801039ae:	e8 ed fb ff ff       	call   801035a0 <allocproc>
801039b3:	85 c0                	test   %eax,%eax
801039b5:	89 c7                	mov    %eax,%edi
801039b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801039ba:	0f 84 63 01 00 00    	je     80103b23 <fork+0x193>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801039c0:	83 ec 08             	sub    $0x8,%esp
801039c3:	ff 33                	pushl  (%ebx)
801039c5:	ff 73 04             	pushl  0x4(%ebx)
801039c8:	e8 63 3d 00 00       	call   80107730 <copyuvm>
801039cd:	83 c4 10             	add    $0x10,%esp
801039d0:	85 c0                	test   %eax,%eax
801039d2:	89 47 04             	mov    %eax,0x4(%edi)
801039d5:	0f 84 4f 01 00 00    	je     80103b2a <fork+0x19a>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
801039db:	8b 03                	mov    (%ebx),%eax
801039dd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  np->parent = curproc;
  *np->tf = *curproc->tf;
801039e0:	b9 13 00 00 00       	mov    $0x13,%ecx
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
801039e5:	89 07                	mov    %eax,(%edi)
  np->parent = curproc;
801039e7:	89 5f 14             	mov    %ebx,0x14(%edi)
  *np->tf = *curproc->tf;
801039ea:	89 f8                	mov    %edi,%eax
801039ec:	8b 73 18             	mov    0x18(%ebx),%esi
801039ef:	8b 7f 18             	mov    0x18(%edi),%edi
801039f2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)


  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801039f4:	31 f6                	xor    %esi,%esi
  np->parent = curproc;
  *np->tf = *curproc->tf;


  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801039f6:	8b 40 18             	mov    0x18(%eax),%eax
801039f9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
80103a00:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103a04:	85 c0                	test   %eax,%eax
80103a06:	74 13                	je     80103a1b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103a08:	83 ec 0c             	sub    $0xc,%esp
80103a0b:	50                   	push   %eax
80103a0c:	e8 cf d3 ff ff       	call   80100de0 <filedup>
80103a11:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103a14:	83 c4 10             	add    $0x10,%esp
80103a17:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)


  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103a1b:	83 c6 01             	add    $0x1,%esi
80103a1e:	83 fe 10             	cmp    $0x10,%esi
80103a21:	75 dd                	jne    80103a00 <fork+0x70>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103a23:	83 ec 0c             	sub    $0xc,%esp
80103a26:	ff 73 68             	pushl  0x68(%ebx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a29:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103a2c:	e8 ff db ff ff       	call   80101630 <idup>
80103a31:	8b 7d e4             	mov    -0x1c(%ebp),%edi

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a34:	83 c4 0c             	add    $0xc,%esp
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103a37:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a3a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103a3d:	6a 10                	push   $0x10
80103a3f:	53                   	push   %ebx
80103a40:	50                   	push   %eax
80103a41:	e8 fa 12 00 00       	call   80104d40 <safestrcpy>

  pid = np->pid;
80103a46:	8b 47 10             	mov    0x10(%edi),%eax

  acquire(&ptable.lock);
80103a49:	c7 04 24 00 47 11 80 	movl   $0x80114700,(%esp)
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;
80103a50:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  acquire(&ptable.lock);
80103a53:	e8 e8 0f 00 00       	call   80104a40 <acquire>

  np->state = RUNNABLE;
80103a58:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
80103a5f:	c7 04 24 00 47 11 80 	movl   $0x80114700,(%esp)
80103a66:	e8 85 10 00 00       	call   80104af0 <release>
  acquire(&ptable.lock);
80103a6b:	c7 04 24 00 47 11 80 	movl   $0x80114700,(%esp)
80103a72:	e8 c9 0f 00 00       	call   80104a40 <acquire>
           if(p->state == RUNNABLE || p->state == RUNNING)
           {
               //initialze
                  if(p->tickets != 0)
                 {
                  p->stride = (TOTAL_MAX_TICKETS/p->tickets);
80103a77:	8b 3d 0c b0 10 80    	mov    0x8010b00c,%edi
           else
           {

               p->execution_count=0;//LAB-2
               p->execution_time=0;//LAB-2
               p->tickets = DEFAULT_TICKETS;
80103a7d:	8b 35 04 b0 10 80    	mov    0x8010b004,%esi
80103a83:	83 c4 10             	add    $0x10,%esp

  np->state = RUNNABLE;

  release(&ptable.lock);
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a86:	b9 34 47 11 80       	mov    $0x80114734,%ecx
80103a8b:	eb 35                	jmp    80103ac2 <fork+0x132>
80103a8d:	8d 76 00             	lea    0x0(%esi),%esi
                  }
           }
           else
           {

               p->execution_count=0;//LAB-2
80103a90:	c7 81 84 00 00 00 00 	movl   $0x0,0x84(%ecx)
80103a97:	00 00 00 
               p->execution_time=0;//LAB-2
80103a9a:	c7 81 88 00 00 00 00 	movl   $0x0,0x88(%ecx)
80103aa1:	00 00 00 
               p->tickets = DEFAULT_TICKETS;
80103aa4:	89 b1 80 00 00 00    	mov    %esi,0x80(%ecx)
               p->stride = 0;
80103aaa:	c7 81 90 00 00 00 00 	movl   $0x0,0x90(%ecx)
80103ab1:	00 00 00 

  np->state = RUNNABLE;

  release(&ptable.lock);
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ab4:	81 c1 9c 00 00 00    	add    $0x9c,%ecx
80103aba:	81 f9 34 6e 11 80    	cmp    $0x80116e34,%ecx
80103ac0:	74 46                	je     80103b08 <fork+0x178>
           if(p->state == RUNNABLE || p->state == RUNNING)
80103ac2:	8b 41 0c             	mov    0xc(%ecx),%eax
80103ac5:	83 e8 03             	sub    $0x3,%eax
80103ac8:	83 f8 01             	cmp    $0x1,%eax
80103acb:	77 c3                	ja     80103a90 <fork+0x100>
           {
               //initialze
                  if(p->tickets != 0)
80103acd:	8b 99 80 00 00 00    	mov    0x80(%ecx),%ebx
80103ad3:	85 db                	test   %ebx,%ebx
80103ad5:	74 dd                	je     80103ab4 <fork+0x124>
                 {
                  p->stride = (TOTAL_MAX_TICKETS/p->tickets);
80103ad7:	89 f8                	mov    %edi,%eax
                  p->pass = p->stride;   //LAB-2
                  p->execution_count=0;//LAB-2
80103ad9:	c7 81 84 00 00 00 00 	movl   $0x0,0x84(%ecx)
80103ae0:	00 00 00 
                  p->execution_time=0;//LAB-2
80103ae3:	c7 81 88 00 00 00 00 	movl   $0x0,0x88(%ecx)
80103aea:	00 00 00 
           if(p->state == RUNNABLE || p->state == RUNNING)
           {
               //initialze
                  if(p->tickets != 0)
                 {
                  p->stride = (TOTAL_MAX_TICKETS/p->tickets);
80103aed:	99                   	cltd   

  np->state = RUNNABLE;

  release(&ptable.lock);
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103aee:	81 c1 9c 00 00 00    	add    $0x9c,%ecx
           if(p->state == RUNNABLE || p->state == RUNNING)
           {
               //initialze
                  if(p->tickets != 0)
                 {
                  p->stride = (TOTAL_MAX_TICKETS/p->tickets);
80103af4:	f7 fb                	idiv   %ebx
80103af6:	89 41 f4             	mov    %eax,-0xc(%ecx)
                  p->pass = p->stride;   //LAB-2
80103af9:	89 41 f0             	mov    %eax,-0x10(%ecx)

  np->state = RUNNABLE;

  release(&ptable.lock);
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103afc:	81 f9 34 6e 11 80    	cmp    $0x80116e34,%ecx
80103b02:	75 be                	jne    80103ac2 <fork+0x132>
80103b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
               p->execution_time=0;//LAB-2
               p->tickets = DEFAULT_TICKETS;
               p->stride = 0;
           }
}
  release(&ptable.lock);
80103b08:	83 ec 0c             	sub    $0xc,%esp
80103b0b:	68 00 47 11 80       	push   $0x80114700
80103b10:	e8 db 0f 00 00       	call   80104af0 <release>

  return pid;
80103b15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103b18:	83 c4 10             	add    $0x10,%esp
}
80103b1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b1e:	5b                   	pop    %ebx
80103b1f:	5e                   	pop    %esi
80103b20:	5f                   	pop    %edi
80103b21:	5d                   	pop    %ebp
80103b22:	c3                   	ret    
  struct proc *p;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103b23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b28:	eb f1                	jmp    80103b1b <fork+0x18b>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
80103b2a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103b2d:	83 ec 0c             	sub    $0xc,%esp
80103b30:	ff 77 08             	pushl  0x8(%edi)
80103b33:	e8 98 e7 ff ff       	call   801022d0 <kfree>
    np->kstack = 0;
80103b38:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103b3f:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103b46:	83 c4 10             	add    $0x10,%esp
80103b49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b4e:	eb cb                	jmp    80103b1b <fork+0x18b>

80103b50 <clone>:
 * Therefore, file discriptor should be shared
 * And append new stack on the original stack in address space
 * */
int
clone(void* stack,int size)//LAB-3
{
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	57                   	push   %edi
80103b54:	56                   	push   %esi
80103b55:	53                   	push   %ebx
80103b56:	83 ec 24             	sub    $0x24,%esp
  numofthread++;//one clone add one thread
  cprintf("this is clone %d\n",size);
80103b59:	ff 75 0c             	pushl  0xc(%ebp)
 * And append new stack on the original stack in address space
 * */
int
clone(void* stack,int size)//LAB-3
{
  numofthread++;//one clone add one thread
80103b5c:	83 05 bc b5 10 80 01 	addl   $0x1,0x8010b5bc
  cprintf("this is clone %d\n",size);
80103b63:	68 b0 7e 10 80       	push   $0x80107eb0
80103b68:	e8 f3 ca ff ff       	call   80100660 <cprintf>
  int i,pid;
  struct proc *newp;//new process and in here is new thread
  if((newp=allocproc())==0)
80103b6d:	e8 2e fa ff ff       	call   801035a0 <allocproc>
80103b72:	83 c4 10             	add    $0x10,%esp
80103b75:	85 c0                	test   %eax,%eax
80103b77:	0f 84 2b 01 00 00    	je     80103ca8 <clone+0x158>
80103b7d:	89 c3                	mov    %eax,%ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103b7f:	e8 dc 0d 00 00       	call   80104960 <pushcli>
  c = mycpu();
80103b84:	e8 c7 fb ff ff       	call   80103750 <mycpu>
  p = c->proc;
80103b89:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80103b8f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  popcli();
80103b92:	e8 09 0e 00 00       	call   801049a0 <popcli>
  struct proc *newp;//new process and in here is new thread
  if((newp=allocproc())==0)
    return -1;

  struct proc *curproc = myproc();
  newp ->pgdir = curproc->pgdir;
80103b97:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  newp ->sz  = curproc ->sz; // size of process
  newp ->parent = curproc;//parent will be original process
  *newp ->tf = *curproc ->tf;
80103b9a:	8b 7b 18             	mov    0x18(%ebx),%edi
80103b9d:	b9 13 00 00 00       	mov    $0x13,%ecx
  PLACE FOR NEW CLONES THREAD ON TOP OF PARENT'S STACK
  */

  void *bottom_stack= (void*)curproc->tf->esp; //current stack pointer //12156
  void *top_stack = (void*)curproc->tf->ebp +4*sizeof(stack);//why 16? //12200
  cprintf("old esp :%d old ebp %d\n",bottom_stack,top_stack);
80103ba2:	83 ec 04             	sub    $0x4,%esp
  struct proc *newp;//new process and in here is new thread
  if((newp=allocproc())==0)
    return -1;

  struct proc *curproc = myproc();
  newp ->pgdir = curproc->pgdir;
80103ba5:	8b 42 04             	mov    0x4(%edx),%eax

  /* NEED TO GRAB THE LOCATION OF STACK and  curproc->tf->esp
  PLACE FOR NEW CLONES THREAD ON TOP OF PARENT'S STACK
  */

  void *bottom_stack= (void*)curproc->tf->esp; //current stack pointer //12156
80103ba8:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct proc *newp;//new process and in here is new thread
  if((newp=allocproc())==0)
    return -1;

  struct proc *curproc = myproc();
  newp ->pgdir = curproc->pgdir;
80103bab:	89 43 04             	mov    %eax,0x4(%ebx)
  newp ->sz  = curproc ->sz; // size of process
80103bae:	8b 02                	mov    (%edx),%eax
  newp ->parent = curproc;//parent will be original process
80103bb0:	89 53 14             	mov    %edx,0x14(%ebx)
  if((newp=allocproc())==0)
    return -1;

  struct proc *curproc = myproc();
  newp ->pgdir = curproc->pgdir;
  newp ->sz  = curproc ->sz; // size of process
80103bb3:	89 03                	mov    %eax,(%ebx)
  newp ->parent = curproc;//parent will be original process
  *newp ->tf = *curproc ->tf;
80103bb5:	8b 72 18             	mov    0x18(%edx),%esi
80103bb8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  newp ->thread_indictor= 1; //indicator a thread
80103bba:	c7 83 98 00 00 00 01 	movl   $0x1,0x98(%ebx)
80103bc1:	00 00 00 
  newp ->tf -> eax = 0 ;// clone in child will return 0
80103bc4:	8b 43 18             	mov    0x18(%ebx),%eax
80103bc7:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  /* NEED TO GRAB THE LOCATION OF STACK and  curproc->tf->esp
  PLACE FOR NEW CLONES THREAD ON TOP OF PARENT'S STACK
  */

  void *bottom_stack= (void*)curproc->tf->esp; //current stack pointer //12156
80103bce:	8b 42 18             	mov    0x18(%edx),%eax
  void *top_stack = (void*)curproc->tf->ebp +4*sizeof(stack);//why 16? //12200
80103bd1:	8b 70 08             	mov    0x8(%eax),%esi

  /* NEED TO GRAB THE LOCATION OF STACK and  curproc->tf->esp
  PLACE FOR NEW CLONES THREAD ON TOP OF PARENT'S STACK
  */

  void *bottom_stack= (void*)curproc->tf->esp; //current stack pointer //12156
80103bd4:	8b 78 44             	mov    0x44(%eax),%edi
  void *top_stack = (void*)curproc->tf->ebp +4*sizeof(stack);//why 16? //12200
80103bd7:	83 c6 10             	add    $0x10,%esi
  cprintf("old esp :%d old ebp %d\n",bottom_stack,top_stack);
80103bda:	56                   	push   %esi
80103bdb:	57                   	push   %edi
  uint parent_size = (uint)(top_stack - bottom_stack); //positive  44 size of stack!!
80103bdc:	29 fe                	sub    %edi,%esi
  PLACE FOR NEW CLONES THREAD ON TOP OF PARENT'S STACK
  */

  void *bottom_stack= (void*)curproc->tf->esp; //current stack pointer //12156
  void *top_stack = (void*)curproc->tf->ebp +4*sizeof(stack);//why 16? //12200
  cprintf("old esp :%d old ebp %d\n",bottom_stack,top_stack);
80103bde:	68 c2 7e 10 80       	push   $0x80107ec2
80103be3:	e8 78 ca ff ff       	call   80100660 <cprintf>
  uint parent_size = (uint)(top_stack - bottom_stack); //positive  44 size of stack!!
  cprintf("copysize:%d, stack:%d\n",parent_size,stack);
80103be8:	83 c4 0c             	add    $0xc,%esp
80103beb:	ff 75 08             	pushl  0x8(%ebp)
80103bee:	56                   	push   %esi
80103bef:	68 da 7e 10 80       	push   $0x80107eda
80103bf4:	e8 67 ca ff ff       	call   80100660 <cprintf>
  newp->tf->esp = (uint) (stack - parent_size);//40916, stack = 10,936 + 40916
80103bf9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103bfc:	8b 43 18             	mov    0x18(%ebx),%eax
  newp->tf->ebp = (uint) (stack -4*sizeof(stack)); //40944, 10,936 - 16
  cprintf("new stack esp %d ebp: %d\n",newp->tf->esp,newp->tf->ebp);
80103bff:	83 c4 0c             	add    $0xc,%esp
  void *bottom_stack= (void*)curproc->tf->esp; //current stack pointer //12156
  void *top_stack = (void*)curproc->tf->ebp +4*sizeof(stack);//why 16? //12200
  cprintf("old esp :%d old ebp %d\n",bottom_stack,top_stack);
  uint parent_size = (uint)(top_stack - bottom_stack); //positive  44 size of stack!!
  cprintf("copysize:%d, stack:%d\n",parent_size,stack);
  newp->tf->esp = (uint) (stack - parent_size);//40916, stack = 10,936 + 40916
80103c02:	29 f1                	sub    %esi,%ecx
80103c04:	89 48 44             	mov    %ecx,0x44(%eax)
  newp->tf->ebp = (uint) (stack -4*sizeof(stack)); //40944, 10,936 - 16
80103c07:	8b 45 08             	mov    0x8(%ebp),%eax
80103c0a:	8b 53 18             	mov    0x18(%ebx),%edx
  void *bottom_stack= (void*)curproc->tf->esp; //current stack pointer //12156
  void *top_stack = (void*)curproc->tf->ebp +4*sizeof(stack);//why 16? //12200
  cprintf("old esp :%d old ebp %d\n",bottom_stack,top_stack);
  uint parent_size = (uint)(top_stack - bottom_stack); //positive  44 size of stack!!
  cprintf("copysize:%d, stack:%d\n",parent_size,stack);
  newp->tf->esp = (uint) (stack - parent_size);//40916, stack = 10,936 + 40916
80103c0d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  newp->tf->ebp = (uint) (stack -4*sizeof(stack)); //40944, 10,936 - 16
80103c10:	83 e8 10             	sub    $0x10,%eax
80103c13:	89 42 08             	mov    %eax,0x8(%edx)
  cprintf("new stack esp %d ebp: %d\n",newp->tf->esp,newp->tf->ebp);
80103c16:	8b 43 18             	mov    0x18(%ebx),%eax
80103c19:	ff 70 08             	pushl  0x8(%eax)
80103c1c:	ff 70 44             	pushl  0x44(%eax)
80103c1f:	68 f1 7e 10 80       	push   $0x80107ef1
80103c24:	e8 37 ca ff ff       	call   80100660 <cprintf>
  memmove(stack - parent_size,bottom_stack,parent_size); //move current proc esp below new esp
80103c29:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103c2c:	83 c4 0c             	add    $0xc,%esp
80103c2f:	56                   	push   %esi
80103c30:	57                   	push   %edi
80103c31:	51                   	push   %ecx
80103c32:	e8 b9 0f 00 00       	call   80104bf0 <memmove>


  cprintf("new eip:%d\n",newp->tf->eip);
80103c37:	8b 43 18             	mov    0x18(%ebx),%eax
80103c3a:	59                   	pop    %ecx
80103c3b:	5e                   	pop    %esi
80103c3c:	ff 70 38             	pushl  0x38(%eax)
80103c3f:	68 0b 7f 10 80       	push   $0x80107f0b
80103c44:	e8 17 ca ff ff       	call   80100660 <cprintf>
  for(i=0;i<NOFILE;i++)
80103c49:	8b 55 e0             	mov    -0x20(%ebp),%edx
  newp->tf->ebp = (uint) (stack -4*sizeof(stack)); //40944, 10,936 - 16
  cprintf("new stack esp %d ebp: %d\n",newp->tf->esp,newp->tf->ebp);
  memmove(stack - parent_size,bottom_stack,parent_size); //move current proc esp below new esp


  cprintf("new eip:%d\n",newp->tf->eip);
80103c4c:	83 c4 10             	add    $0x10,%esp
  for(i=0;i<NOFILE;i++)
80103c4f:	31 c0                	xor    %eax,%eax
80103c51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  {
    if(curproc->ofile[i])
80103c58:	8b 4c 82 28          	mov    0x28(%edx,%eax,4),%ecx
80103c5c:	85 c9                	test   %ecx,%ecx
80103c5e:	74 04                	je     80103c64 <clone+0x114>
      newp->ofile[i]=(curproc->ofile[i]);
80103c60:	89 4c 83 28          	mov    %ecx,0x28(%ebx,%eax,4)
  cprintf("new stack esp %d ebp: %d\n",newp->tf->esp,newp->tf->ebp);
  memmove(stack - parent_size,bottom_stack,parent_size); //move current proc esp below new esp


  cprintf("new eip:%d\n",newp->tf->eip);
  for(i=0;i<NOFILE;i++)
80103c64:	83 c0 01             	add    $0x1,%eax
80103c67:	83 f8 10             	cmp    $0x10,%eax
80103c6a:	75 ec                	jne    80103c58 <clone+0x108>
  {
    if(curproc->ofile[i])
      newp->ofile[i]=(curproc->ofile[i]);
  }
  newp->cwd = (curproc->cwd);
80103c6c:	8b 42 68             	mov    0x68(%edx),%eax

  pid = newp->pid;
  newp->state = RUNNABLE;
  safestrcpy(newp->name, curproc->name, sizeof(curproc->name));
80103c6f:	83 ec 04             	sub    $0x4,%esp
    if(curproc->ofile[i])
      newp->ofile[i]=(curproc->ofile[i]);
  }
  newp->cwd = (curproc->cwd);

  pid = newp->pid;
80103c72:	8b 73 10             	mov    0x10(%ebx),%esi
  newp->state = RUNNABLE;
80103c75:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  safestrcpy(newp->name, curproc->name, sizeof(curproc->name));
80103c7c:	83 c2 6c             	add    $0x6c,%edx
80103c7f:	83 c3 6c             	add    $0x6c,%ebx
  for(i=0;i<NOFILE;i++)
  {
    if(curproc->ofile[i])
      newp->ofile[i]=(curproc->ofile[i]);
  }
  newp->cwd = (curproc->cwd);
80103c82:	89 43 fc             	mov    %eax,-0x4(%ebx)

  pid = newp->pid;
  newp->state = RUNNABLE;
  safestrcpy(newp->name, curproc->name, sizeof(curproc->name));
80103c85:	6a 10                	push   $0x10
80103c87:	52                   	push   %edx
80103c88:	53                   	push   %ebx
80103c89:	e8 b2 10 00 00       	call   80104d40 <safestrcpy>
  cprintf("In clone function this is a pid %d\n",pid);
80103c8e:	58                   	pop    %eax
80103c8f:	5a                   	pop    %edx
80103c90:	56                   	push   %esi
80103c91:	68 8c 80 10 80       	push   $0x8010808c
80103c96:	e8 c5 c9 ff ff       	call   80100660 <cprintf>

  return pid;
80103c9b:	83 c4 10             	add    $0x10,%esp
80103c9e:	89 f0                	mov    %esi,%eax
}
80103ca0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ca3:	5b                   	pop    %ebx
80103ca4:	5e                   	pop    %esi
80103ca5:	5f                   	pop    %edi
80103ca6:	5d                   	pop    %ebp
80103ca7:	c3                   	ret    
  numofthread++;//one clone add one thread
  cprintf("this is clone %d\n",size);
  int i,pid;
  struct proc *newp;//new process and in here is new thread
  if((newp=allocproc())==0)
    return -1;
80103ca8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103cad:	eb f1                	jmp    80103ca0 <clone+0x150>
80103caf:	90                   	nop

80103cb0 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103cb0:	55                   	push   %ebp
80103cb1:	89 e5                	mov    %esp,%ebp
80103cb3:	57                   	push   %edi
80103cb4:	56                   	push   %esi
80103cb5:	53                   	push   %ebx
80103cb6:	83 ec 18             	sub    $0x18,%esp
  cprintf("starting round robin...\n");
80103cb9:	68 17 7f 10 80       	push   $0x80107f17
80103cbe:	e8 9d c9 ff ff       	call   80100660 <cprintf>
  struct proc *p;
  struct cpu *c = mycpu();
80103cc3:	e8 88 fa ff ff       	call   80103750 <mycpu>
80103cc8:	8d 78 04             	lea    0x4(%eax),%edi
80103ccb:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103ccd:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103cd4:	00 00 00 
80103cd7:	83 c4 10             	add    $0x10,%esp
80103cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103ce0:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103ce1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ce4:	bb 34 47 11 80       	mov    $0x80114734,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103ce9:	68 00 47 11 80       	push   $0x80114700
80103cee:	e8 4d 0d 00 00       	call   80104a40 <acquire>
80103cf3:	83 c4 10             	add    $0x10,%esp
80103cf6:	eb 16                	jmp    80103d0e <scheduler+0x5e>
80103cf8:	90                   	nop
80103cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d00:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
80103d06:	81 fb 34 6e 11 80    	cmp    $0x80116e34,%ebx
80103d0c:	74 52                	je     80103d60 <scheduler+0xb0>
      if(p->state != RUNNABLE)
80103d0e:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103d12:	75 ec                	jne    80103d00 <scheduler+0x50>
        continue;
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103d14:	83 ec 0c             	sub    $0xc,%esp
      if(p->state != RUNNABLE)
        continue;
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103d17:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103d1d:	53                   	push   %ebx
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d1e:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
        continue;
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103d24:	e8 37 35 00 00       	call   80107260 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80103d29:	58                   	pop    %eax
80103d2a:	5a                   	pop    %edx
80103d2b:	ff 73 80             	pushl  -0x80(%ebx)
80103d2e:	57                   	push   %edi
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103d2f:	c7 83 70 ff ff ff 04 	movl   $0x4,-0x90(%ebx)
80103d36:	00 00 00 

      swtch(&(c->scheduler), p->context);
80103d39:	e8 5d 10 00 00       	call   80104d9b <swtch>
      switchkvm();
80103d3e:	e8 fd 34 00 00       	call   80107240 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103d43:	83 c4 10             	add    $0x10,%esp
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d46:	81 fb 34 6e 11 80    	cmp    $0x80116e34,%ebx
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103d4c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103d53:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d56:	75 b6                	jne    80103d0e <scheduler+0x5e>
80103d58:	90                   	nop
80103d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103d60:	83 ec 0c             	sub    $0xc,%esp
80103d63:	68 00 47 11 80       	push   $0x80114700
80103d68:	e8 83 0d 00 00       	call   80104af0 <release>

  }
80103d6d:	83 c4 10             	add    $0x10,%esp
80103d70:	e9 6b ff ff ff       	jmp    80103ce0 <scheduler+0x30>
80103d75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d80 <lottery_scheduler>:
/* This is the lottery implimentation that required change in mpmain(void) in main.c to replace
 * scheduler() line with lottery_scheduler();
 */
void
lottery_scheduler(void)
{
80103d80:	55                   	push   %ebp
80103d81:	89 e5                	mov    %esp,%ebp
80103d83:	57                   	push   %edi
80103d84:	56                   	push   %esi
80103d85:	53                   	push   %ebx
80103d86:	83 ec 28             	sub    $0x28,%esp
  cprintf("starting  lottery...\n");
80103d89:	68 30 7f 10 80       	push   $0x80107f30
80103d8e:	e8 cd c8 ff ff       	call   80100660 <cprintf>
  struct proc *p;
  struct cpu *c = mycpu();
80103d93:	e8 b8 f9 ff ff       	call   80103750 <mycpu>
  c->proc = 0;
80103d98:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103d9f:	00 00 00 
void
lottery_scheduler(void)
{
  cprintf("starting  lottery...\n");
  struct proc *p;
  struct cpu *c = mycpu();
80103da2:	89 c6                	mov    %eax,%esi
80103da4:	8d 40 04             	lea    0x4(%eax),%eax
  c->proc = 0;
80103da7:	83 c4 10             	add    $0x10,%esp
80103daa:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103dad:	8d 76 00             	lea    0x0(%esi),%esi
80103db0:	fb                   	sti    
  uint start = 0;
  for(;;){
    // Enable interrupts on this processor.
    sti();
    start = ticks;
    acquire(&ptable.lock);
80103db1:	83 ec 0c             	sub    $0xc,%esp
  //tracking start of ticks of process
  uint start = 0;
  for(;;){
    // Enable interrupts on this processor.
    sti();
    start = ticks;
80103db4:	8b 3d 80 76 11 80    	mov    0x80117680,%edi
    acquire(&ptable.lock);
    ticket_bin = 0;
    totalTickets = 0;
80103dba:	31 db                	xor    %ebx,%ebx
  uint start = 0;
  for(;;){
    // Enable interrupts on this processor.
    sti();
    start = ticks;
    acquire(&ptable.lock);
80103dbc:	68 00 47 11 80       	push   $0x80114700
80103dc1:	e8 7a 0c 00 00       	call   80104a40 <acquire>
80103dc6:	83 c4 10             	add    $0x10,%esp
    ticket_bin = 0;
    totalTickets = 0;
    winner=0;
  //  current_bin=0;
    //LAB-2 : go through all processs and grab ticket total
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dc9:	b8 34 47 11 80       	mov    $0x80114734,%eax
80103dce:	eb 0c                	jmp    80103ddc <lottery_scheduler+0x5c>
80103dd0:	05 9c 00 00 00       	add    $0x9c,%eax
80103dd5:	3d 34 6e 11 80       	cmp    $0x80116e34,%eax
80103dda:	74 18                	je     80103df4 <lottery_scheduler+0x74>
          if(p->state == RUNNABLE)
80103ddc:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103de0:	75 ee                	jne    80103dd0 <lottery_scheduler+0x50>
            totalTickets = totalTickets + p->tickets;
80103de2:	03 98 80 00 00 00    	add    0x80(%eax),%ebx
    ticket_bin = 0;
    totalTickets = 0;
    winner=0;
  //  current_bin=0;
    //LAB-2 : go through all processs and grab ticket total
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103de8:	05 9c 00 00 00       	add    $0x9c,%eax
80103ded:	3d 34 6e 11 80       	cmp    $0x80116e34,%eax
80103df2:	75 e8                	jne    80103ddc <lottery_scheduler+0x5c>
          if(p->state == RUNNABLE)
            totalTickets = totalTickets + p->tickets;
    }
    release(&ptable.lock);
80103df4:	83 ec 0c             	sub    $0xc,%esp

   winner = genrand() % (totalTickets + 1);
80103df7:	83 c3 01             	add    $0x1,%ebx
    //LAB-2 : go through all processs and grab ticket total
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
          if(p->state == RUNNABLE)
            totalTickets = totalTickets + p->tickets;
    }
    release(&ptable.lock);
80103dfa:	68 00 47 11 80       	push   $0x80114700
80103dff:	e8 ec 0c 00 00       	call   80104af0 <release>

   winner = genrand() % (totalTickets + 1);
80103e04:	e8 37 30 00 00       	call   80106e40 <genrand>
80103e09:	99                   	cltd   

   // allocate_info(); //used for making FIGURE 9.

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103e0a:	c7 04 24 00 47 11 80 	movl   $0x80114700,(%esp)
          if(p->state == RUNNABLE)
            totalTickets = totalTickets + p->tickets;
    }
    release(&ptable.lock);

   winner = genrand() % (totalTickets + 1);
80103e11:	f7 fb                	idiv   %ebx
   // allocate_info(); //used for making FIGURE 9.

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e13:	bb 34 47 11 80       	mov    $0x80114734,%ebx
          if(p->state == RUNNABLE)
            totalTickets = totalTickets + p->tickets;
    }
    release(&ptable.lock);

   winner = genrand() % (totalTickets + 1);
80103e18:	89 55 e4             	mov    %edx,-0x1c(%ebp)

   // allocate_info(); //used for making FIGURE 9.

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103e1b:	e8 20 0c 00 00       	call   80104a40 <acquire>
80103e20:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Enable interrupts on this processor.
    sti();
    start = ticks;
    acquire(&ptable.lock);
    ticket_bin = 0;
80103e23:	31 c0                	xor    %eax,%eax
   // allocate_info(); //used for making FIGURE 9.

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e25:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e28:	eb 14                	jmp    80103e3e <lottery_scheduler+0xbe>
80103e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103e30:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
80103e36:	81 fb 34 6e 11 80    	cmp    $0x80116e34,%ebx
80103e3c:	74 67                	je     80103ea5 <lottery_scheduler+0x125>
      if(p->state != RUNNABLE)
80103e3e:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103e42:	75 ec                	jne    80103e30 <lottery_scheduler+0xb0>
        continue;

    //check who is the winner in which bin
   //   current_bin = ticket_bin + p->tickets;
      if( ticket_bin + p->tickets < winner)
80103e44:	8b 8b 80 00 00 00    	mov    0x80(%ebx),%ecx
80103e4a:	01 c8                	add    %ecx,%eax
80103e4c:	39 c2                	cmp    %eax,%edx
80103e4e:	7f e0                	jg     80103e30 <lottery_scheduler+0xb0>
      {
         ticket_bin += p->tickets;
         continue;
      }

      if(p->tickets > 1){
80103e50:	83 f9 01             	cmp    $0x1,%ecx
80103e53:	7e 07                	jle    80103e5c <lottery_scheduler+0xdc>
          p->execution_count++; //keep track of # of runs
80103e55:	83 83 84 00 00 00 01 	addl   $0x1,0x84(%ebx)
     //  allocate_info(); //used for making FIGURE 9.
       // Switch to chosen process.  It is the process's job
       // to release ptable.lock and then reacquire it
       // before jumping back to us.
       c->proc = p;
       switchuvm(p);
80103e5c:	83 ec 0c             	sub    $0xc,%esp
      }
     //  allocate_info(); //used for making FIGURE 9.
       // Switch to chosen process.  It is the process's job
       // to release ptable.lock and then reacquire it
       // before jumping back to us.
       c->proc = p;
80103e5f:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
       switchuvm(p);
80103e65:	53                   	push   %ebx
80103e66:	e8 f5 33 00 00       	call   80107260 <switchuvm>
       p->state = RUNNING;
80103e6b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
       swtch(&(c->scheduler), p->context);
80103e72:	58                   	pop    %eax
80103e73:	5a                   	pop    %edx
80103e74:	ff 73 1c             	pushl  0x1c(%ebx)
80103e77:	ff 75 e0             	pushl  -0x20(%ebp)
80103e7a:	e8 1c 0f 00 00       	call   80104d9b <swtch>
       switchkvm();
80103e7f:	e8 bc 33 00 00       	call   80107240 <switchkvm>
       //number of ticks process has run.
       // Process is done running for now.
       p->execution_time += ticks - start;
80103e84:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
       // It should have changed its p->state before coming back.
       c->proc = 0;
       break;
80103e8a:	83 c4 10             	add    $0x10,%esp
       p->state = RUNNING;
       swtch(&(c->scheduler), p->context);
       switchkvm();
       //number of ticks process has run.
       // Process is done running for now.
       p->execution_time += ticks - start;
80103e8d:	29 f8                	sub    %edi,%eax
80103e8f:	03 05 80 76 11 80    	add    0x80117680,%eax
80103e95:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
       // It should have changed its p->state before coming back.
       c->proc = 0;
80103e9b:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103ea2:	00 00 00 
       break;
    }
    release(&ptable.lock);
80103ea5:	83 ec 0c             	sub    $0xc,%esp
80103ea8:	68 00 47 11 80       	push   $0x80114700
80103ead:	e8 3e 0c 00 00       	call   80104af0 <release>
    start = 0;
  }
80103eb2:	83 c4 10             	add    $0x10,%esp
80103eb5:	e9 f6 fe ff ff       	jmp    80103db0 <lottery_scheduler+0x30>
80103eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ec0 <stride_scheduler>:
/* This is the stride implimentation that requires change in mpmain(void) in main.c to replace
 * scheduler() line with stride_scheduler();
 */
void
stride_scheduler(void)
{
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	57                   	push   %edi
80103ec4:	56                   	push   %esi
80103ec5:	53                   	push   %ebx
  cprintf("starting stride scheduler...\n");
  struct proc *p;
  struct proc *min=0;
80103ec6:	31 ff                	xor    %edi,%edi
/* This is the stride implimentation that requires change in mpmain(void) in main.c to replace
 * scheduler() line with stride_scheduler();
 */
void
stride_scheduler(void)
{
80103ec8:	83 ec 28             	sub    $0x28,%esp
  cprintf("starting stride scheduler...\n");
80103ecb:	68 46 7f 10 80       	push   $0x80107f46
80103ed0:	e8 8b c7 ff ff       	call   80100660 <cprintf>
  struct proc *p;
  struct proc *min=0;
  struct cpu *c = mycpu();
80103ed5:	e8 76 f8 ff ff       	call   80103750 <mycpu>

  c->proc = 0;
80103eda:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103ee1:	00 00 00 
stride_scheduler(void)
{
  cprintf("starting stride scheduler...\n");
  struct proc *p;
  struct proc *min=0;
  struct cpu *c = mycpu();
80103ee4:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103ee7:	83 c0 04             	add    $0x4,%eax

  c->proc = 0;
80103eea:	83 c4 10             	add    $0x10,%esp
80103eed:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103ef0:	fb                   	sti    
  uint start = 0;

  for(;;){
    // Enable interrupts on this processor.
    sti();
    start = ticks;
80103ef1:	a1 80 76 11 80       	mov    0x80117680,%eax
    acquire(&ptable.lock);
80103ef6:	83 ec 0c             	sub    $0xc,%esp
80103ef9:	68 00 47 11 80       	push   $0x80114700
  uint start = 0;

  for(;;){
    // Enable interrupts on this processor.
    sti();
    start = ticks;
80103efe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    acquire(&ptable.lock);
80103f01:	e8 3a 0b 00 00       	call   80104a40 <acquire>
                continue;
           if(p->pass < minpass)
               {
                   minpass = p->pass;
                   if(p->tickets !=0)
                   p->stride = (TOTAL_MAX_TICKETS/p->tickets);
80103f06:	a1 0c b0 10 80       	mov    0x8010b00c,%eax
  for(;;){
    // Enable interrupts on this processor.
    sti();
    start = ticks;
    acquire(&ptable.lock);
    int minpass = max;
80103f0b:	8b 35 10 b0 10 80    	mov    0x8010b010,%esi
                continue;
           if(p->pass < minpass)
               {
                   minpass = p->pass;
                   if(p->tickets !=0)
                   p->stride = (TOTAL_MAX_TICKETS/p->tickets);
80103f11:	83 c4 10             	add    $0x10,%esp
    start = ticks;
    acquire(&ptable.lock);
    int minpass = max;

    //Find process with minimum current pass.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f14:	b9 34 47 11 80       	mov    $0x80114734,%ecx
                continue;
           if(p->pass < minpass)
               {
                   minpass = p->pass;
                   if(p->tickets !=0)
                   p->stride = (TOTAL_MAX_TICKETS/p->tickets);
80103f19:	89 c2                	mov    %eax,%edx
    start = ticks;
    acquire(&ptable.lock);
    int minpass = max;

    //Find process with minimum current pass.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f1b:	89 f8                	mov    %edi,%eax
80103f1d:	89 d7                	mov    %edx,%edi
80103f1f:	eb 15                	jmp    80103f36 <stride_scheduler+0x76>
80103f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f28:	81 c1 9c 00 00 00    	add    $0x9c,%ecx
80103f2e:	81 f9 34 6e 11 80    	cmp    $0x80116e34,%ecx
80103f34:	74 3a                	je     80103f70 <stride_scheduler+0xb0>
    {
           if(p->state != RUNNABLE)
80103f36:	83 79 0c 03          	cmpl   $0x3,0xc(%ecx)
80103f3a:	75 ec                	jne    80103f28 <stride_scheduler+0x68>
                continue;
           if(p->pass < minpass)
80103f3c:	8b 99 8c 00 00 00    	mov    0x8c(%ecx),%ebx
80103f42:	39 f3                	cmp    %esi,%ebx
80103f44:	7d e2                	jge    80103f28 <stride_scheduler+0x68>
               {
                   minpass = p->pass;
                   if(p->tickets !=0)
80103f46:	8b b1 80 00 00 00    	mov    0x80(%ecx),%esi
80103f4c:	85 f6                	test   %esi,%esi
80103f4e:	74 60                	je     80103fb0 <stride_scheduler+0xf0>
                   p->stride = (TOTAL_MAX_TICKETS/p->tickets);
80103f50:	89 f8                	mov    %edi,%eax
80103f52:	99                   	cltd   
80103f53:	f7 fe                	idiv   %esi
80103f55:	89 de                	mov    %ebx,%esi
80103f57:	89 81 90 00 00 00    	mov    %eax,0x90(%ecx)
80103f5d:	89 c8                	mov    %ecx,%eax
    start = ticks;
    acquire(&ptable.lock);
    int minpass = max;

    //Find process with minimum current pass.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f5f:	81 c1 9c 00 00 00    	add    $0x9c,%ecx
80103f65:	81 f9 34 6e 11 80    	cmp    $0x80116e34,%ecx
80103f6b:	75 c9                	jne    80103f36 <stride_scheduler+0x76>
80103f6d:	8d 76 00             	lea    0x0(%esi),%esi
                   p->stride = (TOTAL_MAX_TICKETS/p->tickets);
                   min= p;

               }
     }
    release(&ptable.lock);
80103f70:	83 ec 0c             	sub    $0xc,%esp
80103f73:	89 c7                	mov    %eax,%edi
80103f75:	68 00 47 11 80       	push   $0x80114700
80103f7a:	e8 71 0b 00 00       	call   80104af0 <release>


    acquire(&ptable.lock);
80103f7f:	c7 04 24 00 47 11 80 	movl   $0x80114700,(%esp)
80103f86:	e8 b5 0a 00 00       	call   80104a40 <acquire>
    if(min && min->state==RUNNABLE )
80103f8b:	83 c4 10             	add    $0x10,%esp
80103f8e:	85 ff                	test   %edi,%edi
80103f90:	74 06                	je     80103f98 <stride_scheduler+0xd8>
80103f92:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
80103f96:	74 21                	je     80103fb9 <stride_scheduler+0xf9>
       p->execution_time += ticks - start;
       // Process is done running for now.
       // It should have changed its p->state before coming back.
       c->proc = 0;
    }
    release(&ptable.lock);
80103f98:	83 ec 0c             	sub    $0xc,%esp
80103f9b:	68 00 47 11 80       	push   $0x80114700
80103fa0:	e8 4b 0b 00 00       	call   80104af0 <release>
    start = 0;
  }
80103fa5:	83 c4 10             	add    $0x10,%esp
80103fa8:	e9 43 ff ff ff       	jmp    80103ef0 <stride_scheduler+0x30>
80103fad:	8d 76 00             	lea    0x0(%esi),%esi
80103fb0:	89 de                	mov    %ebx,%esi
80103fb2:	89 c8                	mov    %ecx,%eax
80103fb4:	e9 6f ff ff ff       	jmp    80103f28 <stride_scheduler+0x68>


    acquire(&ptable.lock);
    if(min && min->state==RUNNABLE )
     {
        if(minpass >= max && minpass >0)
80103fb9:	3b 35 10 b0 10 80    	cmp    0x8010b010,%esi
80103fbf:	7c 26                	jl     80103fe7 <stride_scheduler+0x127>
80103fc1:	85 f6                	test   %esi,%esi
80103fc3:	ba 34 47 11 80       	mov    $0x80114734,%edx
80103fc8:	7e 1d                	jle    80103fe7 <stride_scheduler+0x127>
80103fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
       {
          for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
                   p->pass = p->stride;
80103fd0:	8b 82 90 00 00 00    	mov    0x90(%edx),%eax
    acquire(&ptable.lock);
    if(min && min->state==RUNNABLE )
     {
        if(minpass >= max && minpass >0)
       {
          for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fd6:	81 c2 9c 00 00 00    	add    $0x9c,%edx
                   p->pass = p->stride;
80103fdc:	89 42 f0             	mov    %eax,-0x10(%edx)
    acquire(&ptable.lock);
    if(min && min->state==RUNNABLE )
     {
        if(minpass >= max && minpass >0)
       {
          for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fdf:	81 fa 34 6e 11 80    	cmp    $0x80116e34,%edx
80103fe5:	75 e9                	jne    80103fd0 <stride_scheduler+0x110>
        p->execution_count++; //keep track of # of runs
     //   allocate_info(); //used for making FIGURE 9.
       // Switch to chosen process.  It is the process's job
       // to release ptable.lock and then reacquire it
       // before jumping back to us.
       c->proc = p;
80103fe7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
          for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
                   p->pass = p->stride;
       }

        p= min;
        p->pass = p->pass + p->stride;
80103fea:	8b 97 90 00 00 00    	mov    0x90(%edi),%edx
     //   allocate_info(); //used for making FIGURE 9.
       // Switch to chosen process.  It is the process's job
       // to release ptable.lock and then reacquire it
       // before jumping back to us.
       c->proc = p;
       switchuvm(p);
80103ff0:	83 ec 0c             	sub    $0xc,%esp
          for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
                   p->pass = p->stride;
       }

        p= min;
        p->pass = p->pass + p->stride;
80103ff3:	01 97 8c 00 00 00    	add    %edx,0x8c(%edi)
        p->execution_count++; //keep track of # of runs
80103ff9:	83 87 84 00 00 00 01 	addl   $0x1,0x84(%edi)
     //   allocate_info(); //used for making FIGURE 9.
       // Switch to chosen process.  It is the process's job
       // to release ptable.lock and then reacquire it
       // before jumping back to us.
       c->proc = p;
80104000:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
       switchuvm(p);
80104006:	57                   	push   %edi
80104007:	e8 54 32 00 00       	call   80107260 <switchuvm>

       p->state = RUNNING;
8010400c:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)

       swtch(&(c->scheduler), p->context);
80104013:	58                   	pop    %eax
80104014:	5a                   	pop    %edx
80104015:	ff 77 1c             	pushl  0x1c(%edi)
80104018:	ff 75 dc             	pushl  -0x24(%ebp)
8010401b:	e8 7b 0d 00 00       	call   80104d9b <swtch>
       switchkvm();
80104020:	e8 1b 32 00 00       	call   80107240 <switchkvm>
       //number of ticks process has run.
       p->execution_time += ticks - start;
80104025:	8b 97 88 00 00 00    	mov    0x88(%edi),%edx
8010402b:	2b 55 e4             	sub    -0x1c(%ebp),%edx
       // Process is done running for now.
       // It should have changed its p->state before coming back.
       c->proc = 0;
8010402e:	83 c4 10             	add    $0x10,%esp
       p->state = RUNNING;

       swtch(&(c->scheduler), p->context);
       switchkvm();
       //number of ticks process has run.
       p->execution_time += ticks - start;
80104031:	03 15 80 76 11 80    	add    0x80117680,%edx
80104037:	89 97 88 00 00 00    	mov    %edx,0x88(%edi)
       // Process is done running for now.
       // It should have changed its p->state before coming back.
       c->proc = 0;
8010403d:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80104044:	00 00 00 
80104047:	e9 4c ff ff ff       	jmp    80103f98 <stride_scheduler+0xd8>
8010404c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104050 <allocate_info>:
}


//collect amount of allocation total for graphs results//LAB-2
int
allocate_info(void){
80104050:	55                   	push   %ebp

    struct proc *p;
    int total_all =0;
80104051:	31 c9                	xor    %ecx,%ecx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104053:	b8 34 47 11 80       	mov    $0x80114734,%eax
}


//collect amount of allocation total for graphs results//LAB-2
int
allocate_info(void){
80104058:	89 e5                	mov    %esp,%ebp
8010405a:	53                   	push   %ebx
8010405b:	83 ec 04             	sub    $0x4,%esp
8010405e:	eb 0c                	jmp    8010406c <allocate_info+0x1c>

    struct proc *p;
    int total_all =0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104060:	05 9c 00 00 00       	add    $0x9c,%eax
80104065:	3d 34 6e 11 80       	cmp    $0x80116e34,%eax
8010406a:	74 1d                	je     80104089 <allocate_info+0x39>
    {
         if(p->state == RUNNABLE || p->state == RUNNING)
8010406c:	8b 58 0c             	mov    0xc(%eax),%ebx
8010406f:	8d 53 fd             	lea    -0x3(%ebx),%edx
80104072:	83 fa 01             	cmp    $0x1,%edx
80104075:	77 e9                	ja     80104060 <allocate_info+0x10>
         {
        total_all +=p->execution_count;
80104077:	03 88 84 00 00 00    	add    0x84(%eax),%ecx
int
allocate_info(void){

    struct proc *p;
    int total_all =0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010407d:	05 9c 00 00 00       	add    $0x9c,%eax
80104082:	3d 34 6e 11 80       	cmp    $0x80116e34,%eax
80104087:	75 e3                	jne    8010406c <allocate_info+0x1c>
         {
        total_all +=p->execution_count;

         }
    }
    if (total_all == ALLOCATION_COUNT)
80104089:	3b 0d 08 b0 10 80    	cmp    0x8010b008,%ecx
8010408f:	74 07                	je     80104098 <allocate_info+0x48>

        }
    }

    return 0;
}
80104091:	31 c0                	xor    %eax,%eax
80104093:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104096:	c9                   	leave  
80104097:	c3                   	ret    
80104098:	bb a0 47 11 80       	mov    $0x801147a0,%ebx
8010409d:	eb 0f                	jmp    801040ae <allocate_info+0x5e>
8010409f:	90                   	nop
801040a0:	81 c3 9c 00 00 00    	add    $0x9c,%ebx

         }
    }
    if (total_all == ALLOCATION_COUNT)
    {
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040a6:	81 fb a0 6e 11 80    	cmp    $0x80116ea0,%ebx
801040ac:	74 e3                	je     80104091 <allocate_info+0x41>
        {
                if(p->name[0] =='p')
801040ae:	80 3b 70             	cmpb   $0x70,(%ebx)
801040b1:	75 ed                	jne    801040a0 <allocate_info+0x50>
                cprintf("%s's with pid:%d, scheduled times=%d tickets=%d\n", p->name,p->pid, p->execution_count,p->tickets);
801040b3:	83 ec 0c             	sub    $0xc,%esp
801040b6:	ff 73 14             	pushl  0x14(%ebx)
801040b9:	ff 73 18             	pushl  0x18(%ebx)
801040bc:	ff 73 a4             	pushl  -0x5c(%ebx)
801040bf:	53                   	push   %ebx
801040c0:	68 b0 80 10 80       	push   $0x801080b0
801040c5:	e8 96 c5 ff ff       	call   80100660 <cprintf>
801040ca:	83 c4 20             	add    $0x20,%esp
801040cd:	eb d1                	jmp    801040a0 <allocate_info+0x50>
801040cf:	90                   	nop

801040d0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	56                   	push   %esi
801040d4:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801040d5:	e8 86 08 00 00       	call   80104960 <pushcli>
  c = mycpu();
801040da:	e8 71 f6 ff ff       	call   80103750 <mycpu>
  p = c->proc;
801040df:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040e5:	e8 b6 08 00 00       	call   801049a0 <popcli>
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
801040ea:	83 ec 0c             	sub    $0xc,%esp
801040ed:	68 00 47 11 80       	push   $0x80114700
801040f2:	e8 19 09 00 00       	call   80104a10 <holding>
801040f7:	83 c4 10             	add    $0x10,%esp
801040fa:	85 c0                	test   %eax,%eax
801040fc:	74 4f                	je     8010414d <sched+0x7d>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
801040fe:	e8 4d f6 ff ff       	call   80103750 <mycpu>
80104103:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010410a:	75 68                	jne    80104174 <sched+0xa4>
    panic("sched locks");
  if(p->state == RUNNING)
8010410c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104110:	74 55                	je     80104167 <sched+0x97>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104112:	9c                   	pushf  
80104113:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80104114:	f6 c4 02             	test   $0x2,%ah
80104117:	75 41                	jne    8010415a <sched+0x8a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80104119:	e8 32 f6 ff ff       	call   80103750 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010411e:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80104121:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104127:	e8 24 f6 ff ff       	call   80103750 <mycpu>
8010412c:	83 ec 08             	sub    $0x8,%esp
8010412f:	ff 70 04             	pushl  0x4(%eax)
80104132:	53                   	push   %ebx
80104133:	e8 63 0c 00 00       	call   80104d9b <swtch>
  mycpu()->intena = intena;
80104138:	e8 13 f6 ff ff       	call   80103750 <mycpu>
}
8010413d:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
80104140:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104146:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104149:	5b                   	pop    %ebx
8010414a:	5e                   	pop    %esi
8010414b:	5d                   	pop    %ebp
8010414c:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
8010414d:	83 ec 0c             	sub    $0xc,%esp
80104150:	68 64 7f 10 80       	push   $0x80107f64
80104155:	e8 16 c2 ff ff       	call   80100370 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
8010415a:	83 ec 0c             	sub    $0xc,%esp
8010415d:	68 90 7f 10 80       	push   $0x80107f90
80104162:	e8 09 c2 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80104167:	83 ec 0c             	sub    $0xc,%esp
8010416a:	68 82 7f 10 80       	push   $0x80107f82
8010416f:	e8 fc c1 ff ff       	call   80100370 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80104174:	83 ec 0c             	sub    $0xc,%esp
80104177:	68 76 7f 10 80       	push   $0x80107f76
8010417c:	e8 ef c1 ff ff       	call   80100370 <panic>
80104181:	eb 0d                	jmp    80104190 <exit>
80104183:	90                   	nop
80104184:	90                   	nop
80104185:	90                   	nop
80104186:	90                   	nop
80104187:	90                   	nop
80104188:	90                   	nop
80104189:	90                   	nop
8010418a:	90                   	nop
8010418b:	90                   	nop
8010418c:	90                   	nop
8010418d:	90                   	nop
8010418e:	90                   	nop
8010418f:	90                   	nop

80104190 <exit>:
  return pid;
}

void
exit(void)
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	57                   	push   %edi
80104194:	56                   	push   %esi
80104195:	53                   	push   %ebx
80104196:	83 ec 18             	sub    $0x18,%esp
    cprintf("enter exit..\n");
80104199:	68 a4 7f 10 80       	push   $0x80107fa4
8010419e:	e8 bd c4 ff ff       	call   80100660 <cprintf>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801041a3:	e8 b8 07 00 00       	call   80104960 <pushcli>
  c = mycpu();
801041a8:	e8 a3 f5 ff ff       	call   80103750 <mycpu>
  p = c->proc;
801041ad:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801041b3:	e8 e8 07 00 00       	call   801049a0 <popcli>
    cprintf("enter exit..\n");
  struct proc *curproc = myproc();

  struct proc *p;
  int fd;
    if(curproc == initproc)
801041b8:	83 c4 10             	add    $0x10,%esp
801041bb:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
801041c1:	0f 84 32 01 00 00    	je     801042f9 <exit+0x169>
      panic("init exiting");

    if (numofthread==0) //LAB-3
801041c7:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
801041cc:	85 c0                	test   %eax,%eax
801041ce:	75 4e                	jne    8010421e <exit+0x8e>
801041d0:	8d 5e 28             	lea    0x28(%esi),%ebx
801041d3:	8d 7e 68             	lea    0x68(%esi),%edi
801041d6:	8d 76 00             	lea    0x0(%esi),%esi
801041d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    {
        for(fd = 0; fd < NOFILE; fd++){
        if(curproc->ofile[fd]){
801041e0:	8b 03                	mov    (%ebx),%eax
801041e2:	85 c0                	test   %eax,%eax
801041e4:	74 12                	je     801041f8 <exit+0x68>
            fileclose(curproc->ofile[fd]);
801041e6:	83 ec 0c             	sub    $0xc,%esp
801041e9:	50                   	push   %eax
801041ea:	e8 41 cc ff ff       	call   80100e30 <fileclose>
            curproc->ofile[fd] = 0;
801041ef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801041f5:	83 c4 10             	add    $0x10,%esp
801041f8:	83 c3 04             	add    $0x4,%ebx
    if(curproc == initproc)
      panic("init exiting");

    if (numofthread==0) //LAB-3
    {
        for(fd = 0; fd < NOFILE; fd++){
801041fb:	39 df                	cmp    %ebx,%edi
801041fd:	75 e1                	jne    801041e0 <exit+0x50>
            fileclose(curproc->ofile[fd]);
            curproc->ofile[fd] = 0;
            }
        }

    begin_op();
801041ff:	e8 3c e9 ff ff       	call   80102b40 <begin_op>
    iput(curproc->cwd);
80104204:	83 ec 0c             	sub    $0xc,%esp
80104207:	ff 76 68             	pushl  0x68(%esi)
8010420a:	e8 81 d5 ff ff       	call   80101790 <iput>
    end_op();
8010420f:	e8 9c e9 ff ff       	call   80102bb0 <end_op>
    curproc->cwd = 0;
80104214:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
8010421b:	83 c4 10             	add    $0x10,%esp
    }
    acquire(&ptable.lock);
8010421e:	83 ec 0c             	sub    $0xc,%esp
80104221:	68 00 47 11 80       	push   $0x80114700
80104226:	e8 15 08 00 00       	call   80104a40 <acquire>

    //parents might be sleeping in wait
    wakeup1(curproc->parent);
8010422b:	8b 56 14             	mov    0x14(%esi),%edx
8010422e:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104231:	b8 34 47 11 80       	mov    $0x80114734,%eax
80104236:	eb 14                	jmp    8010424c <exit+0xbc>
80104238:	90                   	nop
80104239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104240:	05 9c 00 00 00       	add    $0x9c,%eax
80104245:	3d 34 6e 11 80       	cmp    $0x80116e34,%eax
8010424a:	74 24                	je     80104270 <exit+0xe0>
    if(p->state == SLEEPING && p->chan == chan)
8010424c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104250:	75 ee                	jne    80104240 <exit+0xb0>
80104252:	3b 50 20             	cmp    0x20(%eax),%edx
80104255:	75 e9                	jne    80104240 <exit+0xb0>
      p->state = RUNNABLE;
80104257:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010425e:	05 9c 00 00 00       	add    $0x9c,%eax
80104263:	3d 34 6e 11 80       	cmp    $0x80116e34,%eax
80104268:	75 e2                	jne    8010424c <exit+0xbc>
8010426a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104270:	bb 34 47 11 80       	mov    $0x80114734,%ebx
80104275:	eb 17                	jmp    8010428e <exit+0xfe>
80104277:	89 f6                	mov    %esi,%esi
80104279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    acquire(&ptable.lock);

    //parents might be sleeping in wait
    wakeup1(curproc->parent);
    //pass the children to init
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104280:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
80104286:	81 fb 34 6e 11 80    	cmp    $0x80116e34,%ebx
8010428c:	74 52                	je     801042e0 <exit+0x150>
      if(p->parent == curproc){
8010428e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104291:	75 ed                	jne    80104280 <exit+0xf0>
          cprintf("enter parent == current, p->PID:%d \n", p->pid);
80104293:	83 ec 08             	sub    $0x8,%esp
80104296:	ff 73 10             	pushl  0x10(%ebx)
80104299:	68 e4 80 10 80       	push   $0x801080e4
8010429e:	e8 bd c3 ff ff       	call   80100660 <cprintf>
        p->parent = initproc;
        if(p->state == ZOMBIE)
801042a3:	83 c4 10             	add    $0x10,%esp
801042a6:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
    wakeup1(curproc->parent);
    //pass the children to init
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent == curproc){
          cprintf("enter parent == current, p->PID:%d \n", p->pid);
        p->parent = initproc;
801042aa:	8b 15 b8 b5 10 80    	mov    0x8010b5b8,%edx
801042b0:	89 53 14             	mov    %edx,0x14(%ebx)
        if(p->state == ZOMBIE)
801042b3:	75 cb                	jne    80104280 <exit+0xf0>
801042b5:	b8 34 47 11 80       	mov    $0x80114734,%eax
801042ba:	eb 10                	jmp    801042cc <exit+0x13c>
801042bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042c0:	05 9c 00 00 00       	add    $0x9c,%eax
801042c5:	3d 34 6e 11 80       	cmp    $0x80116e34,%eax
801042ca:	74 b4                	je     80104280 <exit+0xf0>
    if(p->state == SLEEPING && p->chan == chan)
801042cc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801042d0:	75 ee                	jne    801042c0 <exit+0x130>
801042d2:	3b 50 20             	cmp    0x20(%eax),%edx
801042d5:	75 e9                	jne    801042c0 <exit+0x130>
      p->state = RUNNABLE;
801042d7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801042de:	eb e0                	jmp    801042c0 <exit+0x130>
          wakeup1(initproc);
      }
    }

    //jump to the scheduler and never return
    curproc->state = ZOMBIE;
801042e0:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
    sched();
801042e7:	e8 e4 fd ff ff       	call   801040d0 <sched>
    panic("zombie exit");
801042ec:	83 ec 0c             	sub    $0xc,%esp
801042ef:	68 bf 7f 10 80       	push   $0x80107fbf
801042f4:	e8 77 c0 ff ff       	call   80100370 <panic>
  struct proc *curproc = myproc();

  struct proc *p;
  int fd;
    if(curproc == initproc)
      panic("init exiting");
801042f9:	83 ec 0c             	sub    $0xc,%esp
801042fc:	68 b2 7f 10 80       	push   $0x80107fb2
80104301:	e8 6a c0 ff ff       	call   80100370 <panic>
80104306:	8d 76 00             	lea    0x0(%esi),%esi
80104309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104310 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	53                   	push   %ebx
80104314:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104317:	68 00 47 11 80       	push   $0x80114700
8010431c:	e8 1f 07 00 00       	call   80104a40 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104321:	e8 3a 06 00 00       	call   80104960 <pushcli>
  c = mycpu();
80104326:	e8 25 f4 ff ff       	call   80103750 <mycpu>
  p = c->proc;
8010432b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104331:	e8 6a 06 00 00       	call   801049a0 <popcli>
// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
80104336:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010433d:	e8 8e fd ff ff       	call   801040d0 <sched>
  release(&ptable.lock);
80104342:	c7 04 24 00 47 11 80 	movl   $0x80114700,(%esp)
80104349:	e8 a2 07 00 00       	call   80104af0 <release>
}
8010434e:	83 c4 10             	add    $0x10,%esp
80104351:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104354:	c9                   	leave  
80104355:	c3                   	ret    
80104356:	8d 76 00             	lea    0x0(%esi),%esi
80104359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104360 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	57                   	push   %edi
80104364:	56                   	push   %esi
80104365:	53                   	push   %ebx
80104366:	83 ec 0c             	sub    $0xc,%esp
80104369:	8b 7d 08             	mov    0x8(%ebp),%edi
8010436c:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
8010436f:	e8 ec 05 00 00       	call   80104960 <pushcli>
  c = mycpu();
80104374:	e8 d7 f3 ff ff       	call   80103750 <mycpu>
  p = c->proc;
80104379:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010437f:	e8 1c 06 00 00       	call   801049a0 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
80104384:	85 db                	test   %ebx,%ebx
80104386:	0f 84 87 00 00 00    	je     80104413 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
8010438c:	85 f6                	test   %esi,%esi
8010438e:	74 76                	je     80104406 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104390:	81 fe 00 47 11 80    	cmp    $0x80114700,%esi
80104396:	74 50                	je     801043e8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104398:	83 ec 0c             	sub    $0xc,%esp
8010439b:	68 00 47 11 80       	push   $0x80114700
801043a0:	e8 9b 06 00 00       	call   80104a40 <acquire>
    release(lk);
801043a5:	89 34 24             	mov    %esi,(%esp)
801043a8:	e8 43 07 00 00       	call   80104af0 <release>
  }
  // Go to sleep.
  //cprintf("GOING TO BED!!!!\n");
  p->chan = chan;
801043ad:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801043b0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
801043b7:	e8 14 fd ff ff       	call   801040d0 <sched>

  // Tidy up.
  p->chan = 0;
801043bc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
801043c3:	c7 04 24 00 47 11 80 	movl   $0x80114700,(%esp)
801043ca:	e8 21 07 00 00       	call   80104af0 <release>
    acquire(lk);
801043cf:	89 75 08             	mov    %esi,0x8(%ebp)
801043d2:	83 c4 10             	add    $0x10,%esp
  }
}
801043d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043d8:	5b                   	pop    %ebx
801043d9:	5e                   	pop    %esi
801043da:	5f                   	pop    %edi
801043db:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
801043dc:	e9 5f 06 00 00       	jmp    80104a40 <acquire>
801043e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  //cprintf("GOING TO BED!!!!\n");
  p->chan = chan;
801043e8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801043eb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
801043f2:	e8 d9 fc ff ff       	call   801040d0 <sched>

  // Tidy up.
  p->chan = 0;
801043f7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
801043fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104401:	5b                   	pop    %ebx
80104402:	5e                   	pop    %esi
80104403:	5f                   	pop    %edi
80104404:	5d                   	pop    %ebp
80104405:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80104406:	83 ec 0c             	sub    $0xc,%esp
80104409:	68 d1 7f 10 80       	push   $0x80107fd1
8010440e:	e8 5d bf ff ff       	call   80100370 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80104413:	83 ec 0c             	sub    $0xc,%esp
80104416:	68 cb 7f 10 80       	push   $0x80107fcb
8010441b:	e8 50 bf ff ff       	call   80100370 <panic>

80104420 <wait>:
    panic("zombie exit");
}

int
wait(void)
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	56                   	push   %esi
80104424:	53                   	push   %ebx
  cprintf("ENTER WAIT\n");
80104425:	83 ec 0c             	sub    $0xc,%esp
80104428:	68 e2 7f 10 80       	push   $0x80107fe2
8010442d:	e8 2e c2 ff ff       	call   80100660 <cprintf>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104432:	e8 29 05 00 00       	call   80104960 <pushcli>
  c = mycpu();
80104437:	e8 14 f3 ff ff       	call   80103750 <mycpu>
  p = c->proc;
8010443c:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104442:	e8 59 05 00 00       	call   801049a0 <popcli>
  cprintf("ENTER WAIT\n");
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
80104447:	c7 04 24 00 47 11 80 	movl   $0x80114700,(%esp)
8010444e:	e8 ed 05 00 00       	call   80104a40 <acquire>
80104453:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80104456:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104458:	bb 34 47 11 80       	mov    $0x80114734,%ebx
8010445d:	eb 0f                	jmp    8010446e <wait+0x4e>
8010445f:	90                   	nop
80104460:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
80104466:	81 fb 34 6e 11 80    	cmp    $0x80116e34,%ebx
8010446c:	74 22                	je     80104490 <wait+0x70>
      if(p->parent != curproc) //LAB-3- if current == parent or current has
8010446e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104471:	75 ed                	jne    80104460 <wait+0x40>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80104473:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104477:	74 55                	je     801044ce <wait+0xae>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104479:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
      if(p->parent != curproc) //LAB-3- if current == parent or current has
        continue;
      havekids = 1;
8010447f:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104484:	81 fb 34 6e 11 80    	cmp    $0x80116e34,%ebx
8010448a:	75 e2                	jne    8010446e <wait+0x4e>
8010448c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104490:	85 c0                	test   %eax,%eax
80104492:	0f 84 d2 00 00 00    	je     8010456a <wait+0x14a>
80104498:	8b 4e 24             	mov    0x24(%esi),%ecx
8010449b:	85 c9                	test   %ecx,%ecx
8010449d:	0f 85 c7 00 00 00    	jne    8010456a <wait+0x14a>
      release(&ptable.lock);
      return -1;
    }
    cprintf("EXIT SLEEP for parent\n");
801044a3:	83 ec 0c             	sub    $0xc,%esp
801044a6:	68 ff 7f 10 80       	push   $0x80107fff
801044ab:	e8 b0 c1 ff ff       	call   80100660 <cprintf>

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801044b0:	58                   	pop    %eax
801044b1:	5a                   	pop    %edx
801044b2:	68 00 47 11 80       	push   $0x80114700
801044b7:	56                   	push   %esi
801044b8:	e8 a3 fe ff ff       	call   80104360 <sleep>
    cprintf("EXIT SLEEP for parent\n");
801044bd:	c7 04 24 ff 7f 10 80 	movl   $0x80107fff,(%esp)
801044c4:	e8 97 c1 ff ff       	call   80100660 <cprintf>

  }
801044c9:	83 c4 10             	add    $0x10,%esp
801044cc:	eb 88                	jmp    80104456 <wait+0x36>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc) //LAB-3- if current == parent or current has
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        if(p->thread_indictor == 1)//clone
801044ce:	83 bb 98 00 00 00 01 	cmpl   $0x1,0x98(%ebx)
801044d5:	74 56                	je     8010452d <wait+0x10d>
            release(&ptable.lock);
            return pid;
        }
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
801044d7:	83 ec 0c             	sub    $0xc,%esp
            pid = p->pid;
            release(&ptable.lock);
            return pid;
        }
        // Found one.
        pid = p->pid;
801044da:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801044dd:	ff 73 08             	pushl  0x8(%ebx)
801044e0:	e8 eb dd ff ff       	call   801022d0 <kfree>
        p->kstack = 0;
801044e5:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801044ec:	58                   	pop    %eax
801044ed:	ff 73 04             	pushl  0x4(%ebx)
801044f0:	e8 eb 30 00 00       	call   801075e0 <freevm>
        p->pid = 0;
801044f5:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801044fc:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104503:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104507:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010450e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104515:	c7 04 24 00 47 11 80 	movl   $0x80114700,(%esp)
8010451c:	e8 cf 05 00 00       	call   80104af0 <release>
        return pid;
80104521:	83 c4 10             	add    $0x10,%esp
    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
    cprintf("EXIT SLEEP for parent\n");

  }
}
80104524:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80104527:	89 f0                	mov    %esi,%eax
    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
    cprintf("EXIT SLEEP for parent\n");

  }
}
80104529:	5b                   	pop    %ebx
8010452a:	5e                   	pop    %esi
8010452b:	5d                   	pop    %ebp
8010452c:	c3                   	ret    
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        if(p->thread_indictor == 1)//clone
        {
            numofthread--;
8010452d:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
            cprintf("count thread:%d\n",numofthread);
80104532:	83 ec 08             	sub    $0x8,%esp
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        if(p->thread_indictor == 1)//clone
        {
            numofthread--;
80104535:	83 e8 01             	sub    $0x1,%eax
            cprintf("count thread:%d\n",numofthread);
80104538:	50                   	push   %eax
80104539:	68 ee 7f 10 80       	push   $0x80107fee
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        if(p->thread_indictor == 1)//clone
        {
            numofthread--;
8010453e:	a3 bc b5 10 80       	mov    %eax,0x8010b5bc
            cprintf("count thread:%d\n",numofthread);
80104543:	e8 18 c1 ff ff       	call   80100660 <cprintf>
            p->state = UNUSED;
80104548:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
            pid = p->pid;
8010454f:	8b 5b 10             	mov    0x10(%ebx),%ebx
            release(&ptable.lock);
80104552:	c7 04 24 00 47 11 80 	movl   $0x80114700,(%esp)
80104559:	e8 92 05 00 00       	call   80104af0 <release>
            return pid;
8010455e:	83 c4 10             	add    $0x10,%esp
    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
    cprintf("EXIT SLEEP for parent\n");

  }
}
80104561:	8d 65 f8             	lea    -0x8(%ebp),%esp
            numofthread--;
            cprintf("count thread:%d\n",numofthread);
            p->state = UNUSED;
            pid = p->pid;
            release(&ptable.lock);
            return pid;
80104564:	89 d8                	mov    %ebx,%eax
    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
    cprintf("EXIT SLEEP for parent\n");

  }
}
80104566:	5b                   	pop    %ebx
80104567:	5e                   	pop    %esi
80104568:	5d                   	pop    %ebp
80104569:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
8010456a:	83 ec 0c             	sub    $0xc,%esp
8010456d:	68 00 47 11 80       	push   $0x80114700
80104572:	e8 79 05 00 00       	call   80104af0 <release>
      return -1;
80104577:	83 c4 10             	add    $0x10,%esp
    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
    cprintf("EXIT SLEEP for parent\n");

  }
}
8010457a:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
8010457d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
    cprintf("EXIT SLEEP for parent\n");

  }
}
80104582:	5b                   	pop    %ebx
80104583:	5e                   	pop    %esi
80104584:	5d                   	pop    %ebp
80104585:	c3                   	ret    
80104586:	8d 76 00             	lea    0x0(%esi),%esi
80104589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104590 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	53                   	push   %ebx
80104594:	83 ec 10             	sub    $0x10,%esp
80104597:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010459a:	68 00 47 11 80       	push   $0x80114700
8010459f:	e8 9c 04 00 00       	call   80104a40 <acquire>
801045a4:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045a7:	b8 34 47 11 80       	mov    $0x80114734,%eax
801045ac:	eb 0e                	jmp    801045bc <wakeup+0x2c>
801045ae:	66 90                	xchg   %ax,%ax
801045b0:	05 9c 00 00 00       	add    $0x9c,%eax
801045b5:	3d 34 6e 11 80       	cmp    $0x80116e34,%eax
801045ba:	74 1e                	je     801045da <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
801045bc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801045c0:	75 ee                	jne    801045b0 <wakeup+0x20>
801045c2:	3b 58 20             	cmp    0x20(%eax),%ebx
801045c5:	75 e9                	jne    801045b0 <wakeup+0x20>
      p->state = RUNNABLE;
801045c7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045ce:	05 9c 00 00 00       	add    $0x9c,%eax
801045d3:	3d 34 6e 11 80       	cmp    $0x80116e34,%eax
801045d8:	75 e2                	jne    801045bc <wakeup+0x2c>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
801045da:	c7 45 08 00 47 11 80 	movl   $0x80114700,0x8(%ebp)
}
801045e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045e4:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
801045e5:	e9 06 05 00 00       	jmp    80104af0 <release>
801045ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045f0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	53                   	push   %ebx
801045f4:	83 ec 10             	sub    $0x10,%esp
801045f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801045fa:	68 00 47 11 80       	push   $0x80114700
801045ff:	e8 3c 04 00 00       	call   80104a40 <acquire>
80104604:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104607:	b8 34 47 11 80       	mov    $0x80114734,%eax
8010460c:	eb 0e                	jmp    8010461c <kill+0x2c>
8010460e:	66 90                	xchg   %ax,%ax
80104610:	05 9c 00 00 00       	add    $0x9c,%eax
80104615:	3d 34 6e 11 80       	cmp    $0x80116e34,%eax
8010461a:	74 3c                	je     80104658 <kill+0x68>
    if(p->pid == pid){
8010461c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010461f:	75 ef                	jne    80104610 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104621:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80104625:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010462c:	74 1a                	je     80104648 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
8010462e:	83 ec 0c             	sub    $0xc,%esp
80104631:	68 00 47 11 80       	push   $0x80114700
80104636:	e8 b5 04 00 00       	call   80104af0 <release>
      return 0;
8010463b:	83 c4 10             	add    $0x10,%esp
8010463e:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104640:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104643:	c9                   	leave  
80104644:	c3                   	ret    
80104645:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80104648:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010464f:	eb dd                	jmp    8010462e <kill+0x3e>
80104651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104658:	83 ec 0c             	sub    $0xc,%esp
8010465b:	68 00 47 11 80       	push   $0x80114700
80104660:	e8 8b 04 00 00       	call   80104af0 <release>
  return -1;
80104665:	83 c4 10             	add    $0x10,%esp
80104668:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010466d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104670:	c9                   	leave  
80104671:	c3                   	ret    
80104672:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104680 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	57                   	push   %edi
80104684:	56                   	push   %esi
80104685:	53                   	push   %ebx
80104686:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104689:	bb a0 47 11 80       	mov    $0x801147a0,%ebx
8010468e:	83 ec 3c             	sub    $0x3c,%esp
80104691:	eb 27                	jmp    801046ba <procdump+0x3a>
80104693:	90                   	nop
80104694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104698:	83 ec 0c             	sub    $0xc,%esp
8010469b:	68 63 84 10 80       	push   $0x80108463
801046a0:	e8 bb bf ff ff       	call   80100660 <cprintf>
801046a5:	83 c4 10             	add    $0x10,%esp
801046a8:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046ae:	81 fb a0 6e 11 80    	cmp    $0x80116ea0,%ebx
801046b4:	0f 84 96 00 00 00    	je     80104750 <procdump+0xd0>
    if(p->state == UNUSED)
801046ba:	8b 43 a0             	mov    -0x60(%ebx),%eax
801046bd:	85 c0                	test   %eax,%eax
801046bf:	74 e7                	je     801046a8 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801046c1:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
801046c4:	ba 16 80 10 80       	mov    $0x80108016,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801046c9:	77 11                	ja     801046dc <procdump+0x5c>
801046cb:	8b 14 85 0c 81 10 80 	mov    -0x7fef7ef4(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
801046d2:	b8 16 80 10 80       	mov    $0x80108016,%eax
801046d7:	85 d2                	test   %edx,%edx
801046d9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s tickets:%d count:%d ", p->pid, state, p->name,p->tickets,p->execution_count);
801046dc:	83 ec 08             	sub    $0x8,%esp
801046df:	ff 73 18             	pushl  0x18(%ebx)
801046e2:	ff 73 14             	pushl  0x14(%ebx)
801046e5:	53                   	push   %ebx
801046e6:	52                   	push   %edx
801046e7:	ff 73 a4             	pushl  -0x5c(%ebx)
801046ea:	68 1a 80 10 80       	push   $0x8010801a
801046ef:	e8 6c bf ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801046f4:	83 c4 20             	add    $0x20,%esp
801046f7:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801046fb:	75 9b                	jne    80104698 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801046fd:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104700:	83 ec 08             	sub    $0x8,%esp
80104703:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104706:	50                   	push   %eax
80104707:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010470a:	8b 40 0c             	mov    0xc(%eax),%eax
8010470d:	83 c0 08             	add    $0x8,%eax
80104710:	50                   	push   %eax
80104711:	e8 ea 01 00 00       	call   80104900 <getcallerpcs>
80104716:	83 c4 10             	add    $0x10,%esp
80104719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104720:	8b 17                	mov    (%edi),%edx
80104722:	85 d2                	test   %edx,%edx
80104724:	0f 84 6e ff ff ff    	je     80104698 <procdump+0x18>
        cprintf(" %p", pc[i]);
8010472a:	83 ec 08             	sub    $0x8,%esp
8010472d:	83 c7 04             	add    $0x4,%edi
80104730:	52                   	push   %edx
80104731:	68 61 79 10 80       	push   $0x80107961
80104736:	e8 25 bf ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s tickets:%d count:%d ", p->pid, state, p->name,p->tickets,p->execution_count);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
8010473b:	83 c4 10             	add    $0x10,%esp
8010473e:	39 f7                	cmp    %esi,%edi
80104740:	75 de                	jne    80104720 <procdump+0xa0>
80104742:	e9 51 ff ff ff       	jmp    80104698 <procdump+0x18>
80104747:	89 f6                	mov    %esi,%esi
80104749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104750:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104753:	5b                   	pop    %ebx
80104754:	5e                   	pop    %esi
80104755:	5f                   	pop    %edi
80104756:	5d                   	pop    %ebp
80104757:	c3                   	ret    
80104758:	90                   	nop
80104759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104760 <running_processes>:

// grabs a list of the processes being utilized in the system
//LAB-1
int 
running_processes(void)
{
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	53                   	push   %ebx
    int n=0;
80104764:	31 db                	xor    %ebx,%ebx

// grabs a list of the processes being utilized in the system
//LAB-1
int 
running_processes(void)
{
80104766:	83 ec 10             	sub    $0x10,%esp
    int n=0;
    struct proc *p;
    acquire(&ptable.lock);
80104769:	68 00 47 11 80       	push   $0x80114700
8010476e:	e8 cd 02 00 00       	call   80104a40 <acquire>
80104773:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104776:	ba 34 47 11 80       	mov    $0x80114734,%edx
8010477b:	90                   	nop
8010477c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          // check the ptable to see if a process is actually being used
          if(p->state != UNUSED) n++;
80104780:	83 7a 0c 01          	cmpl   $0x1,0xc(%edx)
80104784:	83 db ff             	sbb    $0xffffffff,%ebx
running_processes(void)
{
    int n=0;
    struct proc *p;
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104787:	81 c2 9c 00 00 00    	add    $0x9c,%edx
8010478d:	81 fa 34 6e 11 80    	cmp    $0x80116e34,%edx
80104793:	75 eb                	jne    80104780 <running_processes+0x20>
          // check the ptable to see if a process is actually being used
          if(p->state != UNUSED) n++;
      }
    release(&ptable.lock);
80104795:	83 ec 0c             	sub    $0xc,%esp
80104798:	68 00 47 11 80       	push   $0x80114700
8010479d:	e8 4e 03 00 00       	call   80104af0 <release>
    return n;
}
801047a2:	89 d8                	mov    %ebx,%eax
801047a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047a7:	c9                   	leave  
801047a8:	c3                   	ret    
801047a9:	66 90                	xchg   %ax,%ax
801047ab:	66 90                	xchg   %ax,%ax
801047ad:	66 90                	xchg   %ax,%ax
801047af:	90                   	nop

801047b0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	53                   	push   %ebx
801047b4:	83 ec 0c             	sub    $0xc,%esp
801047b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801047ba:	68 24 81 10 80       	push   $0x80108124
801047bf:	8d 43 04             	lea    0x4(%ebx),%eax
801047c2:	50                   	push   %eax
801047c3:	e8 18 01 00 00       	call   801048e0 <initlock>
  lk->name = name;
801047c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801047cb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801047d1:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
801047d4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
801047db:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
801047de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047e1:	c9                   	leave  
801047e2:	c3                   	ret    
801047e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047f0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	56                   	push   %esi
801047f4:	53                   	push   %ebx
801047f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801047f8:	83 ec 0c             	sub    $0xc,%esp
801047fb:	8d 73 04             	lea    0x4(%ebx),%esi
801047fe:	56                   	push   %esi
801047ff:	e8 3c 02 00 00       	call   80104a40 <acquire>
  while (lk->locked) {
80104804:	8b 13                	mov    (%ebx),%edx
80104806:	83 c4 10             	add    $0x10,%esp
80104809:	85 d2                	test   %edx,%edx
8010480b:	74 16                	je     80104823 <acquiresleep+0x33>
8010480d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104810:	83 ec 08             	sub    $0x8,%esp
80104813:	56                   	push   %esi
80104814:	53                   	push   %ebx
80104815:	e8 46 fb ff ff       	call   80104360 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
8010481a:	8b 03                	mov    (%ebx),%eax
8010481c:	83 c4 10             	add    $0x10,%esp
8010481f:	85 c0                	test   %eax,%eax
80104821:	75 ed                	jne    80104810 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104823:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104829:	e8 c2 ef ff ff       	call   801037f0 <myproc>
8010482e:	8b 40 10             	mov    0x10(%eax),%eax
80104831:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104834:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104837:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010483a:	5b                   	pop    %ebx
8010483b:	5e                   	pop    %esi
8010483c:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
8010483d:	e9 ae 02 00 00       	jmp    80104af0 <release>
80104842:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104850 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	56                   	push   %esi
80104854:	53                   	push   %ebx
80104855:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104858:	83 ec 0c             	sub    $0xc,%esp
8010485b:	8d 73 04             	lea    0x4(%ebx),%esi
8010485e:	56                   	push   %esi
8010485f:	e8 dc 01 00 00       	call   80104a40 <acquire>
  lk->locked = 0;
80104864:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010486a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104871:	89 1c 24             	mov    %ebx,(%esp)
80104874:	e8 17 fd ff ff       	call   80104590 <wakeup>
  release(&lk->lk);
80104879:	89 75 08             	mov    %esi,0x8(%ebp)
8010487c:	83 c4 10             	add    $0x10,%esp
}
8010487f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104882:	5b                   	pop    %ebx
80104883:	5e                   	pop    %esi
80104884:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104885:	e9 66 02 00 00       	jmp    80104af0 <release>
8010488a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104890 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	57                   	push   %edi
80104894:	56                   	push   %esi
80104895:	53                   	push   %ebx
80104896:	31 ff                	xor    %edi,%edi
80104898:	83 ec 18             	sub    $0x18,%esp
8010489b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010489e:	8d 73 04             	lea    0x4(%ebx),%esi
801048a1:	56                   	push   %esi
801048a2:	e8 99 01 00 00       	call   80104a40 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801048a7:	8b 03                	mov    (%ebx),%eax
801048a9:	83 c4 10             	add    $0x10,%esp
801048ac:	85 c0                	test   %eax,%eax
801048ae:	74 13                	je     801048c3 <holdingsleep+0x33>
801048b0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801048b3:	e8 38 ef ff ff       	call   801037f0 <myproc>
801048b8:	39 58 10             	cmp    %ebx,0x10(%eax)
801048bb:	0f 94 c0             	sete   %al
801048be:	0f b6 c0             	movzbl %al,%eax
801048c1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801048c3:	83 ec 0c             	sub    $0xc,%esp
801048c6:	56                   	push   %esi
801048c7:	e8 24 02 00 00       	call   80104af0 <release>
  return r;
}
801048cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048cf:	89 f8                	mov    %edi,%eax
801048d1:	5b                   	pop    %ebx
801048d2:	5e                   	pop    %esi
801048d3:	5f                   	pop    %edi
801048d4:	5d                   	pop    %ebp
801048d5:	c3                   	ret    
801048d6:	66 90                	xchg   %ax,%ax
801048d8:	66 90                	xchg   %ax,%ax
801048da:	66 90                	xchg   %ax,%ax
801048dc:	66 90                	xchg   %ax,%ax
801048de:	66 90                	xchg   %ax,%ax

801048e0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801048e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801048e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
801048ef:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
801048f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801048f9:	5d                   	pop    %ebp
801048fa:	c3                   	ret    
801048fb:	90                   	nop
801048fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104900 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104904:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104907:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010490a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010490d:	31 c0                	xor    %eax,%eax
8010490f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104910:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104916:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010491c:	77 1a                	ja     80104938 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010491e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104921:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104924:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104927:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104929:	83 f8 0a             	cmp    $0xa,%eax
8010492c:	75 e2                	jne    80104910 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010492e:	5b                   	pop    %ebx
8010492f:	5d                   	pop    %ebp
80104930:	c3                   	ret    
80104931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104938:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010493f:	83 c0 01             	add    $0x1,%eax
80104942:	83 f8 0a             	cmp    $0xa,%eax
80104945:	74 e7                	je     8010492e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104947:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010494e:	83 c0 01             	add    $0x1,%eax
80104951:	83 f8 0a             	cmp    $0xa,%eax
80104954:	75 e2                	jne    80104938 <getcallerpcs+0x38>
80104956:	eb d6                	jmp    8010492e <getcallerpcs+0x2e>
80104958:	90                   	nop
80104959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104960 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	53                   	push   %ebx
80104964:	83 ec 04             	sub    $0x4,%esp
80104967:	9c                   	pushf  
80104968:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104969:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010496a:	e8 e1 ed ff ff       	call   80103750 <mycpu>
8010496f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104975:	85 c0                	test   %eax,%eax
80104977:	75 11                	jne    8010498a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104979:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010497f:	e8 cc ed ff ff       	call   80103750 <mycpu>
80104984:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010498a:	e8 c1 ed ff ff       	call   80103750 <mycpu>
8010498f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104996:	83 c4 04             	add    $0x4,%esp
80104999:	5b                   	pop    %ebx
8010499a:	5d                   	pop    %ebp
8010499b:	c3                   	ret    
8010499c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049a0 <popcli>:

void
popcli(void)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801049a6:	9c                   	pushf  
801049a7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801049a8:	f6 c4 02             	test   $0x2,%ah
801049ab:	75 52                	jne    801049ff <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801049ad:	e8 9e ed ff ff       	call   80103750 <mycpu>
801049b2:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
801049b8:	8d 51 ff             	lea    -0x1(%ecx),%edx
801049bb:	85 d2                	test   %edx,%edx
801049bd:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801049c3:	78 2d                	js     801049f2 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801049c5:	e8 86 ed ff ff       	call   80103750 <mycpu>
801049ca:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801049d0:	85 d2                	test   %edx,%edx
801049d2:	74 0c                	je     801049e0 <popcli+0x40>
    sti();
}
801049d4:	c9                   	leave  
801049d5:	c3                   	ret    
801049d6:	8d 76 00             	lea    0x0(%esi),%esi
801049d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801049e0:	e8 6b ed ff ff       	call   80103750 <mycpu>
801049e5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801049eb:	85 c0                	test   %eax,%eax
801049ed:	74 e5                	je     801049d4 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
801049ef:	fb                   	sti    
    sti();
}
801049f0:	c9                   	leave  
801049f1:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
801049f2:	83 ec 0c             	sub    $0xc,%esp
801049f5:	68 46 81 10 80       	push   $0x80108146
801049fa:	e8 71 b9 ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
801049ff:	83 ec 0c             	sub    $0xc,%esp
80104a02:	68 2f 81 10 80       	push   $0x8010812f
80104a07:	e8 64 b9 ff ff       	call   80100370 <panic>
80104a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a10 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	56                   	push   %esi
80104a14:	53                   	push   %ebx
80104a15:	8b 75 08             	mov    0x8(%ebp),%esi
80104a18:	31 db                	xor    %ebx,%ebx
  int r;
  pushcli();
80104a1a:	e8 41 ff ff ff       	call   80104960 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104a1f:	8b 06                	mov    (%esi),%eax
80104a21:	85 c0                	test   %eax,%eax
80104a23:	74 10                	je     80104a35 <holding+0x25>
80104a25:	8b 5e 08             	mov    0x8(%esi),%ebx
80104a28:	e8 23 ed ff ff       	call   80103750 <mycpu>
80104a2d:	39 c3                	cmp    %eax,%ebx
80104a2f:	0f 94 c3             	sete   %bl
80104a32:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104a35:	e8 66 ff ff ff       	call   801049a0 <popcli>
  return r;
}
80104a3a:	89 d8                	mov    %ebx,%eax
80104a3c:	5b                   	pop    %ebx
80104a3d:	5e                   	pop    %esi
80104a3e:	5d                   	pop    %ebp
80104a3f:	c3                   	ret    

80104a40 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	53                   	push   %ebx
80104a44:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104a47:	e8 14 ff ff ff       	call   80104960 <pushcli>
  if(holding(lk))
80104a4c:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a4f:	83 ec 0c             	sub    $0xc,%esp
80104a52:	53                   	push   %ebx
80104a53:	e8 b8 ff ff ff       	call   80104a10 <holding>
80104a58:	83 c4 10             	add    $0x10,%esp
80104a5b:	85 c0                	test   %eax,%eax
80104a5d:	0f 85 7d 00 00 00    	jne    80104ae0 <acquire+0xa0>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104a63:	ba 01 00 00 00       	mov    $0x1,%edx
80104a68:	eb 09                	jmp    80104a73 <acquire+0x33>
80104a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a70:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a73:	89 d0                	mov    %edx,%eax
80104a75:	f0 87 03             	lock xchg %eax,(%ebx)
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104a78:	85 c0                	test   %eax,%eax
80104a7a:	75 f4                	jne    80104a70 <acquire+0x30>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104a7c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104a81:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a84:	e8 c7 ec ff ff       	call   80103750 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104a89:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
80104a8b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104a8e:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104a91:	31 c0                	xor    %eax,%eax
80104a93:	90                   	nop
80104a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a98:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104a9e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104aa4:	77 1a                	ja     80104ac0 <acquire+0x80>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104aa6:	8b 5a 04             	mov    0x4(%edx),%ebx
80104aa9:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104aac:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104aaf:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104ab1:	83 f8 0a             	cmp    $0xa,%eax
80104ab4:	75 e2                	jne    80104a98 <acquire+0x58>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
80104ab6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ab9:	c9                   	leave  
80104aba:	c3                   	ret    
80104abb:	90                   	nop
80104abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104ac0:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104ac7:	83 c0 01             	add    $0x1,%eax
80104aca:	83 f8 0a             	cmp    $0xa,%eax
80104acd:	74 e7                	je     80104ab6 <acquire+0x76>
    pcs[i] = 0;
80104acf:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104ad6:	83 c0 01             	add    $0x1,%eax
80104ad9:	83 f8 0a             	cmp    $0xa,%eax
80104adc:	75 e2                	jne    80104ac0 <acquire+0x80>
80104ade:	eb d6                	jmp    80104ab6 <acquire+0x76>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104ae0:	83 ec 0c             	sub    $0xc,%esp
80104ae3:	68 4d 81 10 80       	push   $0x8010814d
80104ae8:	e8 83 b8 ff ff       	call   80100370 <panic>
80104aed:	8d 76 00             	lea    0x0(%esi),%esi

80104af0 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	53                   	push   %ebx
80104af4:	83 ec 10             	sub    $0x10,%esp
80104af7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104afa:	53                   	push   %ebx
80104afb:	e8 10 ff ff ff       	call   80104a10 <holding>
80104b00:	83 c4 10             	add    $0x10,%esp
80104b03:	85 c0                	test   %eax,%eax
80104b05:	74 22                	je     80104b29 <release+0x39>
    panic("release");

  lk->pcs[0] = 0;
80104b07:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104b0e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104b15:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104b1a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80104b20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b23:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104b24:	e9 77 fe ff ff       	jmp    801049a0 <popcli>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80104b29:	83 ec 0c             	sub    $0xc,%esp
80104b2c:	68 55 81 10 80       	push   $0x80108155
80104b31:	e8 3a b8 ff ff       	call   80100370 <panic>
80104b36:	66 90                	xchg   %ax,%ax
80104b38:	66 90                	xchg   %ax,%ax
80104b3a:	66 90                	xchg   %ax,%ax
80104b3c:	66 90                	xchg   %ax,%ax
80104b3e:	66 90                	xchg   %ax,%ax

80104b40 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	57                   	push   %edi
80104b44:	53                   	push   %ebx
80104b45:	8b 55 08             	mov    0x8(%ebp),%edx
80104b48:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104b4b:	f6 c2 03             	test   $0x3,%dl
80104b4e:	75 05                	jne    80104b55 <memset+0x15>
80104b50:	f6 c1 03             	test   $0x3,%cl
80104b53:	74 13                	je     80104b68 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104b55:	89 d7                	mov    %edx,%edi
80104b57:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b5a:	fc                   	cld    
80104b5b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104b5d:	5b                   	pop    %ebx
80104b5e:	89 d0                	mov    %edx,%eax
80104b60:	5f                   	pop    %edi
80104b61:	5d                   	pop    %ebp
80104b62:	c3                   	ret    
80104b63:	90                   	nop
80104b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104b68:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104b6c:	c1 e9 02             	shr    $0x2,%ecx
80104b6f:	89 fb                	mov    %edi,%ebx
80104b71:	89 f8                	mov    %edi,%eax
80104b73:	c1 e3 18             	shl    $0x18,%ebx
80104b76:	c1 e0 10             	shl    $0x10,%eax
80104b79:	09 d8                	or     %ebx,%eax
80104b7b:	09 f8                	or     %edi,%eax
80104b7d:	c1 e7 08             	shl    $0x8,%edi
80104b80:	09 f8                	or     %edi,%eax
80104b82:	89 d7                	mov    %edx,%edi
80104b84:	fc                   	cld    
80104b85:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104b87:	5b                   	pop    %ebx
80104b88:	89 d0                	mov    %edx,%eax
80104b8a:	5f                   	pop    %edi
80104b8b:	5d                   	pop    %ebp
80104b8c:	c3                   	ret    
80104b8d:	8d 76 00             	lea    0x0(%esi),%esi

80104b90 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	57                   	push   %edi
80104b94:	56                   	push   %esi
80104b95:	8b 45 10             	mov    0x10(%ebp),%eax
80104b98:	53                   	push   %ebx
80104b99:	8b 75 0c             	mov    0xc(%ebp),%esi
80104b9c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104b9f:	85 c0                	test   %eax,%eax
80104ba1:	74 29                	je     80104bcc <memcmp+0x3c>
    if(*s1 != *s2)
80104ba3:	0f b6 13             	movzbl (%ebx),%edx
80104ba6:	0f b6 0e             	movzbl (%esi),%ecx
80104ba9:	38 d1                	cmp    %dl,%cl
80104bab:	75 2b                	jne    80104bd8 <memcmp+0x48>
80104bad:	8d 78 ff             	lea    -0x1(%eax),%edi
80104bb0:	31 c0                	xor    %eax,%eax
80104bb2:	eb 14                	jmp    80104bc8 <memcmp+0x38>
80104bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bb8:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
80104bbd:	83 c0 01             	add    $0x1,%eax
80104bc0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104bc4:	38 ca                	cmp    %cl,%dl
80104bc6:	75 10                	jne    80104bd8 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104bc8:	39 f8                	cmp    %edi,%eax
80104bca:	75 ec                	jne    80104bb8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104bcc:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104bcd:	31 c0                	xor    %eax,%eax
}
80104bcf:	5e                   	pop    %esi
80104bd0:	5f                   	pop    %edi
80104bd1:	5d                   	pop    %ebp
80104bd2:	c3                   	ret    
80104bd3:	90                   	nop
80104bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104bd8:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
80104bdb:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104bdc:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
80104bde:	5e                   	pop    %esi
80104bdf:	5f                   	pop    %edi
80104be0:	5d                   	pop    %ebp
80104be1:	c3                   	ret    
80104be2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bf0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	56                   	push   %esi
80104bf4:	53                   	push   %ebx
80104bf5:	8b 45 08             	mov    0x8(%ebp),%eax
80104bf8:	8b 75 0c             	mov    0xc(%ebp),%esi
80104bfb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104bfe:	39 c6                	cmp    %eax,%esi
80104c00:	73 2e                	jae    80104c30 <memmove+0x40>
80104c02:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104c05:	39 c8                	cmp    %ecx,%eax
80104c07:	73 27                	jae    80104c30 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104c09:	85 db                	test   %ebx,%ebx
80104c0b:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104c0e:	74 17                	je     80104c27 <memmove+0x37>
      *--d = *--s;
80104c10:	29 d9                	sub    %ebx,%ecx
80104c12:	89 cb                	mov    %ecx,%ebx
80104c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c18:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104c1c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104c1f:	83 ea 01             	sub    $0x1,%edx
80104c22:	83 fa ff             	cmp    $0xffffffff,%edx
80104c25:	75 f1                	jne    80104c18 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104c27:	5b                   	pop    %ebx
80104c28:	5e                   	pop    %esi
80104c29:	5d                   	pop    %ebp
80104c2a:	c3                   	ret    
80104c2b:	90                   	nop
80104c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104c30:	31 d2                	xor    %edx,%edx
80104c32:	85 db                	test   %ebx,%ebx
80104c34:	74 f1                	je     80104c27 <memmove+0x37>
80104c36:	8d 76 00             	lea    0x0(%esi),%esi
80104c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80104c40:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104c44:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104c47:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104c4a:	39 d3                	cmp    %edx,%ebx
80104c4c:	75 f2                	jne    80104c40 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
80104c4e:	5b                   	pop    %ebx
80104c4f:	5e                   	pop    %esi
80104c50:	5d                   	pop    %ebp
80104c51:	c3                   	ret    
80104c52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c60 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104c63:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104c64:	eb 8a                	jmp    80104bf0 <memmove>
80104c66:	8d 76 00             	lea    0x0(%esi),%esi
80104c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c70 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	57                   	push   %edi
80104c74:	56                   	push   %esi
80104c75:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104c78:	53                   	push   %ebx
80104c79:	8b 7d 08             	mov    0x8(%ebp),%edi
80104c7c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104c7f:	85 c9                	test   %ecx,%ecx
80104c81:	74 37                	je     80104cba <strncmp+0x4a>
80104c83:	0f b6 17             	movzbl (%edi),%edx
80104c86:	0f b6 1e             	movzbl (%esi),%ebx
80104c89:	84 d2                	test   %dl,%dl
80104c8b:	74 3f                	je     80104ccc <strncmp+0x5c>
80104c8d:	38 d3                	cmp    %dl,%bl
80104c8f:	75 3b                	jne    80104ccc <strncmp+0x5c>
80104c91:	8d 47 01             	lea    0x1(%edi),%eax
80104c94:	01 cf                	add    %ecx,%edi
80104c96:	eb 1b                	jmp    80104cb3 <strncmp+0x43>
80104c98:	90                   	nop
80104c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ca0:	0f b6 10             	movzbl (%eax),%edx
80104ca3:	84 d2                	test   %dl,%dl
80104ca5:	74 21                	je     80104cc8 <strncmp+0x58>
80104ca7:	0f b6 19             	movzbl (%ecx),%ebx
80104caa:	83 c0 01             	add    $0x1,%eax
80104cad:	89 ce                	mov    %ecx,%esi
80104caf:	38 da                	cmp    %bl,%dl
80104cb1:	75 19                	jne    80104ccc <strncmp+0x5c>
80104cb3:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104cb5:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104cb8:	75 e6                	jne    80104ca0 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104cba:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80104cbb:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80104cbd:	5e                   	pop    %esi
80104cbe:	5f                   	pop    %edi
80104cbf:	5d                   	pop    %ebp
80104cc0:	c3                   	ret    
80104cc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cc8:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104ccc:	0f b6 c2             	movzbl %dl,%eax
80104ccf:	29 d8                	sub    %ebx,%eax
}
80104cd1:	5b                   	pop    %ebx
80104cd2:	5e                   	pop    %esi
80104cd3:	5f                   	pop    %edi
80104cd4:	5d                   	pop    %ebp
80104cd5:	c3                   	ret    
80104cd6:	8d 76 00             	lea    0x0(%esi),%esi
80104cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ce0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	56                   	push   %esi
80104ce4:	53                   	push   %ebx
80104ce5:	8b 45 08             	mov    0x8(%ebp),%eax
80104ce8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104ceb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104cee:	89 c2                	mov    %eax,%edx
80104cf0:	eb 19                	jmp    80104d0b <strncpy+0x2b>
80104cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104cf8:	83 c3 01             	add    $0x1,%ebx
80104cfb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104cff:	83 c2 01             	add    $0x1,%edx
80104d02:	84 c9                	test   %cl,%cl
80104d04:	88 4a ff             	mov    %cl,-0x1(%edx)
80104d07:	74 09                	je     80104d12 <strncpy+0x32>
80104d09:	89 f1                	mov    %esi,%ecx
80104d0b:	85 c9                	test   %ecx,%ecx
80104d0d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104d10:	7f e6                	jg     80104cf8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104d12:	31 c9                	xor    %ecx,%ecx
80104d14:	85 f6                	test   %esi,%esi
80104d16:	7e 17                	jle    80104d2f <strncpy+0x4f>
80104d18:	90                   	nop
80104d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104d20:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104d24:	89 f3                	mov    %esi,%ebx
80104d26:	83 c1 01             	add    $0x1,%ecx
80104d29:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104d2b:	85 db                	test   %ebx,%ebx
80104d2d:	7f f1                	jg     80104d20 <strncpy+0x40>
    *s++ = 0;
  return os;
}
80104d2f:	5b                   	pop    %ebx
80104d30:	5e                   	pop    %esi
80104d31:	5d                   	pop    %ebp
80104d32:	c3                   	ret    
80104d33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d40 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	56                   	push   %esi
80104d44:	53                   	push   %ebx
80104d45:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104d48:	8b 45 08             	mov    0x8(%ebp),%eax
80104d4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104d4e:	85 c9                	test   %ecx,%ecx
80104d50:	7e 26                	jle    80104d78 <safestrcpy+0x38>
80104d52:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104d56:	89 c1                	mov    %eax,%ecx
80104d58:	eb 17                	jmp    80104d71 <safestrcpy+0x31>
80104d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104d60:	83 c2 01             	add    $0x1,%edx
80104d63:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104d67:	83 c1 01             	add    $0x1,%ecx
80104d6a:	84 db                	test   %bl,%bl
80104d6c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104d6f:	74 04                	je     80104d75 <safestrcpy+0x35>
80104d71:	39 f2                	cmp    %esi,%edx
80104d73:	75 eb                	jne    80104d60 <safestrcpy+0x20>
    ;
  *s = 0;
80104d75:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104d78:	5b                   	pop    %ebx
80104d79:	5e                   	pop    %esi
80104d7a:	5d                   	pop    %ebp
80104d7b:	c3                   	ret    
80104d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d80 <strlen>:

int
strlen(const char *s)
{
80104d80:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104d81:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104d83:	89 e5                	mov    %esp,%ebp
80104d85:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104d88:	80 3a 00             	cmpb   $0x0,(%edx)
80104d8b:	74 0c                	je     80104d99 <strlen+0x19>
80104d8d:	8d 76 00             	lea    0x0(%esi),%esi
80104d90:	83 c0 01             	add    $0x1,%eax
80104d93:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104d97:	75 f7                	jne    80104d90 <strlen+0x10>
    ;
  return n;
}
80104d99:	5d                   	pop    %ebp
80104d9a:	c3                   	ret    

80104d9b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104d9b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104d9f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104da3:	55                   	push   %ebp
  pushl %ebx
80104da4:	53                   	push   %ebx
  pushl %esi
80104da5:	56                   	push   %esi
  pushl %edi
80104da6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104da7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104da9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104dab:	5f                   	pop    %edi
  popl %esi
80104dac:	5e                   	pop    %esi
  popl %ebx
80104dad:	5b                   	pop    %ebx
  popl %ebp
80104dae:	5d                   	pop    %ebp
  ret
80104daf:	c3                   	ret    

80104db0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	53                   	push   %ebx
80104db4:	83 ec 04             	sub    $0x4,%esp
80104db7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104dba:	e8 31 ea ff ff       	call   801037f0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104dbf:	8b 00                	mov    (%eax),%eax
80104dc1:	39 d8                	cmp    %ebx,%eax
80104dc3:	76 1b                	jbe    80104de0 <fetchint+0x30>
80104dc5:	8d 53 04             	lea    0x4(%ebx),%edx
80104dc8:	39 d0                	cmp    %edx,%eax
80104dca:	72 14                	jb     80104de0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dcf:	8b 13                	mov    (%ebx),%edx
80104dd1:	89 10                	mov    %edx,(%eax)
  return 0;
80104dd3:	31 c0                	xor    %eax,%eax
}
80104dd5:	83 c4 04             	add    $0x4,%esp
80104dd8:	5b                   	pop    %ebx
80104dd9:	5d                   	pop    %ebp
80104dda:	c3                   	ret    
80104ddb:	90                   	nop
80104ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104de0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104de5:	eb ee                	jmp    80104dd5 <fetchint+0x25>
80104de7:	89 f6                	mov    %esi,%esi
80104de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104df0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104df0:	55                   	push   %ebp
80104df1:	89 e5                	mov    %esp,%ebp
80104df3:	53                   	push   %ebx
80104df4:	83 ec 04             	sub    $0x4,%esp
80104df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104dfa:	e8 f1 e9 ff ff       	call   801037f0 <myproc>

  if(addr >= curproc->sz)
80104dff:	39 18                	cmp    %ebx,(%eax)
80104e01:	76 29                	jbe    80104e2c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104e03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104e06:	89 da                	mov    %ebx,%edx
80104e08:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104e0a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104e0c:	39 c3                	cmp    %eax,%ebx
80104e0e:	73 1c                	jae    80104e2c <fetchstr+0x3c>
    if(*s == 0)
80104e10:	80 3b 00             	cmpb   $0x0,(%ebx)
80104e13:	75 10                	jne    80104e25 <fetchstr+0x35>
80104e15:	eb 29                	jmp    80104e40 <fetchstr+0x50>
80104e17:	89 f6                	mov    %esi,%esi
80104e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104e20:	80 3a 00             	cmpb   $0x0,(%edx)
80104e23:	74 1b                	je     80104e40 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80104e25:	83 c2 01             	add    $0x1,%edx
80104e28:	39 d0                	cmp    %edx,%eax
80104e2a:	77 f4                	ja     80104e20 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104e2c:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
80104e2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104e34:	5b                   	pop    %ebx
80104e35:	5d                   	pop    %ebp
80104e36:	c3                   	ret    
80104e37:	89 f6                	mov    %esi,%esi
80104e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104e40:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80104e43:	89 d0                	mov    %edx,%eax
80104e45:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104e47:	5b                   	pop    %ebx
80104e48:	5d                   	pop    %ebp
80104e49:	c3                   	ret    
80104e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e50 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	56                   	push   %esi
80104e54:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e55:	e8 96 e9 ff ff       	call   801037f0 <myproc>
80104e5a:	8b 40 18             	mov    0x18(%eax),%eax
80104e5d:	8b 55 08             	mov    0x8(%ebp),%edx
80104e60:	8b 40 44             	mov    0x44(%eax),%eax
80104e63:	8d 1c 90             	lea    (%eax,%edx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
80104e66:	e8 85 e9 ff ff       	call   801037f0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e6b:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e6d:	8d 73 04             	lea    0x4(%ebx),%esi
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e70:	39 c6                	cmp    %eax,%esi
80104e72:	73 1c                	jae    80104e90 <argint+0x40>
80104e74:	8d 53 08             	lea    0x8(%ebx),%edx
80104e77:	39 d0                	cmp    %edx,%eax
80104e79:	72 15                	jb     80104e90 <argint+0x40>
    return -1;
  *ip = *(int*)(addr);
80104e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e7e:	8b 53 04             	mov    0x4(%ebx),%edx
80104e81:	89 10                	mov    %edx,(%eax)
  return 0;
80104e83:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
80104e85:	5b                   	pop    %ebx
80104e86:	5e                   	pop    %esi
80104e87:	5d                   	pop    %ebp
80104e88:	c3                   	ret    
80104e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104e90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e95:	eb ee                	jmp    80104e85 <argint+0x35>
80104e97:	89 f6                	mov    %esi,%esi
80104e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ea0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	56                   	push   %esi
80104ea4:	53                   	push   %ebx
80104ea5:	83 ec 10             	sub    $0x10,%esp
80104ea8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104eab:	e8 40 e9 ff ff       	call   801037f0 <myproc>
80104eb0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104eb2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104eb5:	83 ec 08             	sub    $0x8,%esp
80104eb8:	50                   	push   %eax
80104eb9:	ff 75 08             	pushl  0x8(%ebp)
80104ebc:	e8 8f ff ff ff       	call   80104e50 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ec1:	c1 e8 1f             	shr    $0x1f,%eax
80104ec4:	83 c4 10             	add    $0x10,%esp
80104ec7:	84 c0                	test   %al,%al
80104ec9:	75 2d                	jne    80104ef8 <argptr+0x58>
80104ecb:	89 d8                	mov    %ebx,%eax
80104ecd:	c1 e8 1f             	shr    $0x1f,%eax
80104ed0:	84 c0                	test   %al,%al
80104ed2:	75 24                	jne    80104ef8 <argptr+0x58>
80104ed4:	8b 16                	mov    (%esi),%edx
80104ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ed9:	39 c2                	cmp    %eax,%edx
80104edb:	76 1b                	jbe    80104ef8 <argptr+0x58>
80104edd:	01 c3                	add    %eax,%ebx
80104edf:	39 da                	cmp    %ebx,%edx
80104ee1:	72 15                	jb     80104ef8 <argptr+0x58>
    return -1;
  *pp = (char*)i;
80104ee3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ee6:	89 02                	mov    %eax,(%edx)
  return 0;
80104ee8:	31 c0                	xor    %eax,%eax
}
80104eea:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104eed:	5b                   	pop    %ebx
80104eee:	5e                   	pop    %esi
80104eef:	5d                   	pop    %ebp
80104ef0:	c3                   	ret    
80104ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
80104ef8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104efd:	eb eb                	jmp    80104eea <argptr+0x4a>
80104eff:	90                   	nop

80104f00 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104f06:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f09:	50                   	push   %eax
80104f0a:	ff 75 08             	pushl  0x8(%ebp)
80104f0d:	e8 3e ff ff ff       	call   80104e50 <argint>
80104f12:	83 c4 10             	add    $0x10,%esp
80104f15:	85 c0                	test   %eax,%eax
80104f17:	78 17                	js     80104f30 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104f19:	83 ec 08             	sub    $0x8,%esp
80104f1c:	ff 75 0c             	pushl  0xc(%ebp)
80104f1f:	ff 75 f4             	pushl  -0xc(%ebp)
80104f22:	e8 c9 fe ff ff       	call   80104df0 <fetchstr>
80104f27:	83 c4 10             	add    $0x10,%esp
}
80104f2a:	c9                   	leave  
80104f2b:	c3                   	ret    
80104f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104f30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104f35:	c9                   	leave  
80104f36:	c3                   	ret    
80104f37:	89 f6                	mov    %esi,%esi
80104f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f40 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	56                   	push   %esi
80104f44:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80104f45:	e8 a6 e8 ff ff       	call   801037f0 <myproc>

  num = curproc->tf->eax;
80104f4a:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
80104f4d:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104f4f:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104f52:	8d 50 ff             	lea    -0x1(%eax),%edx
80104f55:	83 fa 17             	cmp    $0x17,%edx
80104f58:	77 1e                	ja     80104f78 <syscall+0x38>
80104f5a:	8b 14 85 80 81 10 80 	mov    -0x7fef7e80(,%eax,4),%edx
80104f61:	85 d2                	test   %edx,%edx
80104f63:	74 13                	je     80104f78 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104f65:	ff d2                	call   *%edx
80104f67:	89 46 1c             	mov    %eax,0x1c(%esi)
        curproc->syscall_count++; // LAB-1
80104f6a:	83 43 7c 01          	addl   $0x1,0x7c(%ebx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104f6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f71:	5b                   	pop    %ebx
80104f72:	5e                   	pop    %esi
80104f73:	5d                   	pop    %ebp
80104f74:	c3                   	ret    
80104f75:	8d 76 00             	lea    0x0(%esi),%esi
  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
        curproc->syscall_count++; // LAB-1
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104f78:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104f79:	8d 43 6c             	lea    0x6c(%ebx),%eax
  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
        curproc->syscall_count++; // LAB-1
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104f7c:	50                   	push   %eax
80104f7d:	ff 73 10             	pushl  0x10(%ebx)
80104f80:	68 5d 81 10 80       	push   $0x8010815d
80104f85:	e8 d6 b6 ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
80104f8a:	8b 43 18             	mov    0x18(%ebx),%eax
80104f8d:	83 c4 10             	add    $0x10,%esp
80104f90:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104f97:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f9a:	5b                   	pop    %ebx
80104f9b:	5e                   	pop    %esi
80104f9c:	5d                   	pop    %ebp
80104f9d:	c3                   	ret    
80104f9e:	66 90                	xchg   %ax,%ax

80104fa0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	57                   	push   %edi
80104fa4:	56                   	push   %esi
80104fa5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104fa6:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104fa9:	83 ec 34             	sub    $0x34,%esp
80104fac:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104faf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104fb2:	56                   	push   %esi
80104fb3:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104fb4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104fb7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104fba:	e8 11 cf ff ff       	call   80101ed0 <nameiparent>
80104fbf:	83 c4 10             	add    $0x10,%esp
80104fc2:	85 c0                	test   %eax,%eax
80104fc4:	0f 84 f6 00 00 00    	je     801050c0 <create+0x120>
    return 0;
  ilock(dp);
80104fca:	83 ec 0c             	sub    $0xc,%esp
80104fcd:	89 c7                	mov    %eax,%edi
80104fcf:	50                   	push   %eax
80104fd0:	e8 8b c6 ff ff       	call   80101660 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104fd5:	83 c4 0c             	add    $0xc,%esp
80104fd8:	6a 00                	push   $0x0
80104fda:	56                   	push   %esi
80104fdb:	57                   	push   %edi
80104fdc:	e8 af cb ff ff       	call   80101b90 <dirlookup>
80104fe1:	83 c4 10             	add    $0x10,%esp
80104fe4:	85 c0                	test   %eax,%eax
80104fe6:	89 c3                	mov    %eax,%ebx
80104fe8:	74 56                	je     80105040 <create+0xa0>
    iunlockput(dp);
80104fea:	83 ec 0c             	sub    $0xc,%esp
80104fed:	57                   	push   %edi
80104fee:	e8 fd c8 ff ff       	call   801018f0 <iunlockput>
    ilock(ip);
80104ff3:	89 1c 24             	mov    %ebx,(%esp)
80104ff6:	e8 65 c6 ff ff       	call   80101660 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104ffb:	83 c4 10             	add    $0x10,%esp
80104ffe:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105003:	75 1b                	jne    80105020 <create+0x80>
80105005:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
8010500a:	89 d8                	mov    %ebx,%eax
8010500c:	75 12                	jne    80105020 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010500e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105011:	5b                   	pop    %ebx
80105012:	5e                   	pop    %esi
80105013:	5f                   	pop    %edi
80105014:	5d                   	pop    %ebp
80105015:	c3                   	ret    
80105016:	8d 76 00             	lea    0x0(%esi),%esi
80105019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80105020:	83 ec 0c             	sub    $0xc,%esp
80105023:	53                   	push   %ebx
80105024:	e8 c7 c8 ff ff       	call   801018f0 <iunlockput>
    return 0;
80105029:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010502c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
8010502f:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105031:	5b                   	pop    %ebx
80105032:	5e                   	pop    %esi
80105033:	5f                   	pop    %edi
80105034:	5d                   	pop    %ebp
80105035:	c3                   	ret    
80105036:	8d 76 00             	lea    0x0(%esi),%esi
80105039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105040:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105044:	83 ec 08             	sub    $0x8,%esp
80105047:	50                   	push   %eax
80105048:	ff 37                	pushl  (%edi)
8010504a:	e8 a1 c4 ff ff       	call   801014f0 <ialloc>
8010504f:	83 c4 10             	add    $0x10,%esp
80105052:	85 c0                	test   %eax,%eax
80105054:	89 c3                	mov    %eax,%ebx
80105056:	0f 84 cc 00 00 00    	je     80105128 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
8010505c:	83 ec 0c             	sub    $0xc,%esp
8010505f:	50                   	push   %eax
80105060:	e8 fb c5 ff ff       	call   80101660 <ilock>
  ip->major = major;
80105065:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105069:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
8010506d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105071:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80105075:	b8 01 00 00 00       	mov    $0x1,%eax
8010507a:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
8010507e:	89 1c 24             	mov    %ebx,(%esp)
80105081:	e8 2a c5 ff ff       	call   801015b0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105086:	83 c4 10             	add    $0x10,%esp
80105089:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010508e:	74 40                	je     801050d0 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105090:	83 ec 04             	sub    $0x4,%esp
80105093:	ff 73 04             	pushl  0x4(%ebx)
80105096:	56                   	push   %esi
80105097:	57                   	push   %edi
80105098:	e8 53 cd ff ff       	call   80101df0 <dirlink>
8010509d:	83 c4 10             	add    $0x10,%esp
801050a0:	85 c0                	test   %eax,%eax
801050a2:	78 77                	js     8010511b <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
801050a4:	83 ec 0c             	sub    $0xc,%esp
801050a7:	57                   	push   %edi
801050a8:	e8 43 c8 ff ff       	call   801018f0 <iunlockput>

  return ip;
801050ad:	83 c4 10             	add    $0x10,%esp
}
801050b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
801050b3:	89 d8                	mov    %ebx,%eax
}
801050b5:	5b                   	pop    %ebx
801050b6:	5e                   	pop    %esi
801050b7:	5f                   	pop    %edi
801050b8:	5d                   	pop    %ebp
801050b9:	c3                   	ret    
801050ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
801050c0:	31 c0                	xor    %eax,%eax
801050c2:	e9 47 ff ff ff       	jmp    8010500e <create+0x6e>
801050c7:	89 f6                	mov    %esi,%esi
801050c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
801050d0:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
801050d5:	83 ec 0c             	sub    $0xc,%esp
801050d8:	57                   	push   %edi
801050d9:	e8 d2 c4 ff ff       	call   801015b0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801050de:	83 c4 0c             	add    $0xc,%esp
801050e1:	ff 73 04             	pushl  0x4(%ebx)
801050e4:	68 00 82 10 80       	push   $0x80108200
801050e9:	53                   	push   %ebx
801050ea:	e8 01 cd ff ff       	call   80101df0 <dirlink>
801050ef:	83 c4 10             	add    $0x10,%esp
801050f2:	85 c0                	test   %eax,%eax
801050f4:	78 18                	js     8010510e <create+0x16e>
801050f6:	83 ec 04             	sub    $0x4,%esp
801050f9:	ff 77 04             	pushl  0x4(%edi)
801050fc:	68 ff 81 10 80       	push   $0x801081ff
80105101:	53                   	push   %ebx
80105102:	e8 e9 cc ff ff       	call   80101df0 <dirlink>
80105107:	83 c4 10             	add    $0x10,%esp
8010510a:	85 c0                	test   %eax,%eax
8010510c:	79 82                	jns    80105090 <create+0xf0>
      panic("create dots");
8010510e:	83 ec 0c             	sub    $0xc,%esp
80105111:	68 f3 81 10 80       	push   $0x801081f3
80105116:	e8 55 b2 ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
8010511b:	83 ec 0c             	sub    $0xc,%esp
8010511e:	68 02 82 10 80       	push   $0x80108202
80105123:	e8 48 b2 ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80105128:	83 ec 0c             	sub    $0xc,%esp
8010512b:	68 e4 81 10 80       	push   $0x801081e4
80105130:	e8 3b b2 ff ff       	call   80100370 <panic>
80105135:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105140 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105140:	55                   	push   %ebp
80105141:	89 e5                	mov    %esp,%ebp
80105143:	56                   	push   %esi
80105144:	53                   	push   %ebx
80105145:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105147:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
8010514a:	89 d3                	mov    %edx,%ebx
8010514c:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010514f:	50                   	push   %eax
80105150:	6a 00                	push   $0x0
80105152:	e8 f9 fc ff ff       	call   80104e50 <argint>
80105157:	83 c4 10             	add    $0x10,%esp
8010515a:	85 c0                	test   %eax,%eax
8010515c:	78 32                	js     80105190 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010515e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105162:	77 2c                	ja     80105190 <argfd.constprop.0+0x50>
80105164:	e8 87 e6 ff ff       	call   801037f0 <myproc>
80105169:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010516c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105170:	85 c0                	test   %eax,%eax
80105172:	74 1c                	je     80105190 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80105174:	85 f6                	test   %esi,%esi
80105176:	74 02                	je     8010517a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105178:	89 16                	mov    %edx,(%esi)
  if(pf)
8010517a:	85 db                	test   %ebx,%ebx
8010517c:	74 22                	je     801051a0 <argfd.constprop.0+0x60>
    *pf = f;
8010517e:	89 03                	mov    %eax,(%ebx)
  return 0;
80105180:	31 c0                	xor    %eax,%eax
}
80105182:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105185:	5b                   	pop    %ebx
80105186:	5e                   	pop    %esi
80105187:	5d                   	pop    %ebp
80105188:	c3                   	ret    
80105189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105190:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80105193:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80105198:	5b                   	pop    %ebx
80105199:	5e                   	pop    %esi
8010519a:	5d                   	pop    %ebp
8010519b:	c3                   	ret    
8010519c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
801051a0:	31 c0                	xor    %eax,%eax
801051a2:	eb de                	jmp    80105182 <argfd.constprop.0+0x42>
801051a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801051aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801051b0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
801051b0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801051b1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
801051b3:	89 e5                	mov    %esp,%ebp
801051b5:	56                   	push   %esi
801051b6:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801051b7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
801051ba:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801051bd:	e8 7e ff ff ff       	call   80105140 <argfd.constprop.0>
801051c2:	85 c0                	test   %eax,%eax
801051c4:	78 1a                	js     801051e0 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801051c6:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
801051c8:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801051cb:	e8 20 e6 ff ff       	call   801037f0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
801051d0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801051d4:	85 d2                	test   %edx,%edx
801051d6:	74 18                	je     801051f0 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801051d8:	83 c3 01             	add    $0x1,%ebx
801051db:	83 fb 10             	cmp    $0x10,%ebx
801051de:	75 f0                	jne    801051d0 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
801051e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
801051e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
801051e8:	5b                   	pop    %ebx
801051e9:	5e                   	pop    %esi
801051ea:	5d                   	pop    %ebp
801051eb:	c3                   	ret    
801051ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801051f0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
801051f4:	83 ec 0c             	sub    $0xc,%esp
801051f7:	ff 75 f4             	pushl  -0xc(%ebp)
801051fa:	e8 e1 bb ff ff       	call   80100de0 <filedup>
  return fd;
801051ff:	83 c4 10             	add    $0x10,%esp
}
80105202:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80105205:	89 d8                	mov    %ebx,%eax
}
80105207:	5b                   	pop    %ebx
80105208:	5e                   	pop    %esi
80105209:	5d                   	pop    %ebp
8010520a:	c3                   	ret    
8010520b:	90                   	nop
8010520c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105210 <sys_read>:

int
sys_read(void)
{
80105210:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105211:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80105213:	89 e5                	mov    %esp,%ebp
80105215:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105218:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010521b:	e8 20 ff ff ff       	call   80105140 <argfd.constprop.0>
80105220:	85 c0                	test   %eax,%eax
80105222:	78 4c                	js     80105270 <sys_read+0x60>
80105224:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105227:	83 ec 08             	sub    $0x8,%esp
8010522a:	50                   	push   %eax
8010522b:	6a 02                	push   $0x2
8010522d:	e8 1e fc ff ff       	call   80104e50 <argint>
80105232:	83 c4 10             	add    $0x10,%esp
80105235:	85 c0                	test   %eax,%eax
80105237:	78 37                	js     80105270 <sys_read+0x60>
80105239:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010523c:	83 ec 04             	sub    $0x4,%esp
8010523f:	ff 75 f0             	pushl  -0x10(%ebp)
80105242:	50                   	push   %eax
80105243:	6a 01                	push   $0x1
80105245:	e8 56 fc ff ff       	call   80104ea0 <argptr>
8010524a:	83 c4 10             	add    $0x10,%esp
8010524d:	85 c0                	test   %eax,%eax
8010524f:	78 1f                	js     80105270 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105251:	83 ec 04             	sub    $0x4,%esp
80105254:	ff 75 f0             	pushl  -0x10(%ebp)
80105257:	ff 75 f4             	pushl  -0xc(%ebp)
8010525a:	ff 75 ec             	pushl  -0x14(%ebp)
8010525d:	e8 ee bc ff ff       	call   80100f50 <fileread>
80105262:	83 c4 10             	add    $0x10,%esp
}
80105265:	c9                   	leave  
80105266:	c3                   	ret    
80105267:	89 f6                	mov    %esi,%esi
80105269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105270:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80105275:	c9                   	leave  
80105276:	c3                   	ret    
80105277:	89 f6                	mov    %esi,%esi
80105279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105280 <sys_write>:

int
sys_write(void)
{
80105280:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105281:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80105283:	89 e5                	mov    %esp,%ebp
80105285:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105288:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010528b:	e8 b0 fe ff ff       	call   80105140 <argfd.constprop.0>
80105290:	85 c0                	test   %eax,%eax
80105292:	78 4c                	js     801052e0 <sys_write+0x60>
80105294:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105297:	83 ec 08             	sub    $0x8,%esp
8010529a:	50                   	push   %eax
8010529b:	6a 02                	push   $0x2
8010529d:	e8 ae fb ff ff       	call   80104e50 <argint>
801052a2:	83 c4 10             	add    $0x10,%esp
801052a5:	85 c0                	test   %eax,%eax
801052a7:	78 37                	js     801052e0 <sys_write+0x60>
801052a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052ac:	83 ec 04             	sub    $0x4,%esp
801052af:	ff 75 f0             	pushl  -0x10(%ebp)
801052b2:	50                   	push   %eax
801052b3:	6a 01                	push   $0x1
801052b5:	e8 e6 fb ff ff       	call   80104ea0 <argptr>
801052ba:	83 c4 10             	add    $0x10,%esp
801052bd:	85 c0                	test   %eax,%eax
801052bf:	78 1f                	js     801052e0 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
801052c1:	83 ec 04             	sub    $0x4,%esp
801052c4:	ff 75 f0             	pushl  -0x10(%ebp)
801052c7:	ff 75 f4             	pushl  -0xc(%ebp)
801052ca:	ff 75 ec             	pushl  -0x14(%ebp)
801052cd:	e8 0e bd ff ff       	call   80100fe0 <filewrite>
801052d2:	83 c4 10             	add    $0x10,%esp
}
801052d5:	c9                   	leave  
801052d6:	c3                   	ret    
801052d7:	89 f6                	mov    %esi,%esi
801052d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
801052e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
801052e5:	c9                   	leave  
801052e6:	c3                   	ret    
801052e7:	89 f6                	mov    %esi,%esi
801052e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052f0 <sys_close>:

int
sys_close(void)
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
801052f6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801052f9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052fc:	e8 3f fe ff ff       	call   80105140 <argfd.constprop.0>
80105301:	85 c0                	test   %eax,%eax
80105303:	78 2b                	js     80105330 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105305:	e8 e6 e4 ff ff       	call   801037f0 <myproc>
8010530a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010530d:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80105310:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105317:	00 
  fileclose(f);
80105318:	ff 75 f4             	pushl  -0xc(%ebp)
8010531b:	e8 10 bb ff ff       	call   80100e30 <fileclose>
  return 0;
80105320:	83 c4 10             	add    $0x10,%esp
80105323:	31 c0                	xor    %eax,%eax
}
80105325:	c9                   	leave  
80105326:	c3                   	ret    
80105327:	89 f6                	mov    %esi,%esi
80105329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80105330:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80105335:	c9                   	leave  
80105336:	c3                   	ret    
80105337:	89 f6                	mov    %esi,%esi
80105339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105340 <sys_fstat>:

int
sys_fstat(void)
{
80105340:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105341:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80105343:	89 e5                	mov    %esp,%ebp
80105345:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105348:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010534b:	e8 f0 fd ff ff       	call   80105140 <argfd.constprop.0>
80105350:	85 c0                	test   %eax,%eax
80105352:	78 2c                	js     80105380 <sys_fstat+0x40>
80105354:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105357:	83 ec 04             	sub    $0x4,%esp
8010535a:	6a 14                	push   $0x14
8010535c:	50                   	push   %eax
8010535d:	6a 01                	push   $0x1
8010535f:	e8 3c fb ff ff       	call   80104ea0 <argptr>
80105364:	83 c4 10             	add    $0x10,%esp
80105367:	85 c0                	test   %eax,%eax
80105369:	78 15                	js     80105380 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
8010536b:	83 ec 08             	sub    $0x8,%esp
8010536e:	ff 75 f4             	pushl  -0xc(%ebp)
80105371:	ff 75 f0             	pushl  -0x10(%ebp)
80105374:	e8 87 bb ff ff       	call   80100f00 <filestat>
80105379:	83 c4 10             	add    $0x10,%esp
}
8010537c:	c9                   	leave  
8010537d:	c3                   	ret    
8010537e:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80105380:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80105385:	c9                   	leave  
80105386:	c3                   	ret    
80105387:	89 f6                	mov    %esi,%esi
80105389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105390 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	57                   	push   %edi
80105394:	56                   	push   %esi
80105395:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105396:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105399:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010539c:	50                   	push   %eax
8010539d:	6a 00                	push   $0x0
8010539f:	e8 5c fb ff ff       	call   80104f00 <argstr>
801053a4:	83 c4 10             	add    $0x10,%esp
801053a7:	85 c0                	test   %eax,%eax
801053a9:	0f 88 fb 00 00 00    	js     801054aa <sys_link+0x11a>
801053af:	8d 45 d0             	lea    -0x30(%ebp),%eax
801053b2:	83 ec 08             	sub    $0x8,%esp
801053b5:	50                   	push   %eax
801053b6:	6a 01                	push   $0x1
801053b8:	e8 43 fb ff ff       	call   80104f00 <argstr>
801053bd:	83 c4 10             	add    $0x10,%esp
801053c0:	85 c0                	test   %eax,%eax
801053c2:	0f 88 e2 00 00 00    	js     801054aa <sys_link+0x11a>
    return -1;

  begin_op();
801053c8:	e8 73 d7 ff ff       	call   80102b40 <begin_op>
  if((ip = namei(old)) == 0){
801053cd:	83 ec 0c             	sub    $0xc,%esp
801053d0:	ff 75 d4             	pushl  -0x2c(%ebp)
801053d3:	e8 d8 ca ff ff       	call   80101eb0 <namei>
801053d8:	83 c4 10             	add    $0x10,%esp
801053db:	85 c0                	test   %eax,%eax
801053dd:	89 c3                	mov    %eax,%ebx
801053df:	0f 84 f3 00 00 00    	je     801054d8 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
801053e5:	83 ec 0c             	sub    $0xc,%esp
801053e8:	50                   	push   %eax
801053e9:	e8 72 c2 ff ff       	call   80101660 <ilock>
  if(ip->type == T_DIR){
801053ee:	83 c4 10             	add    $0x10,%esp
801053f1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053f6:	0f 84 c4 00 00 00    	je     801054c0 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
801053fc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105401:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105404:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80105407:	53                   	push   %ebx
80105408:	e8 a3 c1 ff ff       	call   801015b0 <iupdate>
  iunlock(ip);
8010540d:	89 1c 24             	mov    %ebx,(%esp)
80105410:	e8 2b c3 ff ff       	call   80101740 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105415:	58                   	pop    %eax
80105416:	5a                   	pop    %edx
80105417:	57                   	push   %edi
80105418:	ff 75 d0             	pushl  -0x30(%ebp)
8010541b:	e8 b0 ca ff ff       	call   80101ed0 <nameiparent>
80105420:	83 c4 10             	add    $0x10,%esp
80105423:	85 c0                	test   %eax,%eax
80105425:	89 c6                	mov    %eax,%esi
80105427:	74 5b                	je     80105484 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105429:	83 ec 0c             	sub    $0xc,%esp
8010542c:	50                   	push   %eax
8010542d:	e8 2e c2 ff ff       	call   80101660 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105432:	83 c4 10             	add    $0x10,%esp
80105435:	8b 03                	mov    (%ebx),%eax
80105437:	39 06                	cmp    %eax,(%esi)
80105439:	75 3d                	jne    80105478 <sys_link+0xe8>
8010543b:	83 ec 04             	sub    $0x4,%esp
8010543e:	ff 73 04             	pushl  0x4(%ebx)
80105441:	57                   	push   %edi
80105442:	56                   	push   %esi
80105443:	e8 a8 c9 ff ff       	call   80101df0 <dirlink>
80105448:	83 c4 10             	add    $0x10,%esp
8010544b:	85 c0                	test   %eax,%eax
8010544d:	78 29                	js     80105478 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
8010544f:	83 ec 0c             	sub    $0xc,%esp
80105452:	56                   	push   %esi
80105453:	e8 98 c4 ff ff       	call   801018f0 <iunlockput>
  iput(ip);
80105458:	89 1c 24             	mov    %ebx,(%esp)
8010545b:	e8 30 c3 ff ff       	call   80101790 <iput>

  end_op();
80105460:	e8 4b d7 ff ff       	call   80102bb0 <end_op>

  return 0;
80105465:	83 c4 10             	add    $0x10,%esp
80105468:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010546a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010546d:	5b                   	pop    %ebx
8010546e:	5e                   	pop    %esi
8010546f:	5f                   	pop    %edi
80105470:	5d                   	pop    %ebp
80105471:	c3                   	ret    
80105472:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80105478:	83 ec 0c             	sub    $0xc,%esp
8010547b:	56                   	push   %esi
8010547c:	e8 6f c4 ff ff       	call   801018f0 <iunlockput>
    goto bad;
80105481:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80105484:	83 ec 0c             	sub    $0xc,%esp
80105487:	53                   	push   %ebx
80105488:	e8 d3 c1 ff ff       	call   80101660 <ilock>
  ip->nlink--;
8010548d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105492:	89 1c 24             	mov    %ebx,(%esp)
80105495:	e8 16 c1 ff ff       	call   801015b0 <iupdate>
  iunlockput(ip);
8010549a:	89 1c 24             	mov    %ebx,(%esp)
8010549d:	e8 4e c4 ff ff       	call   801018f0 <iunlockput>
  end_op();
801054a2:	e8 09 d7 ff ff       	call   80102bb0 <end_op>
  return -1;
801054a7:	83 c4 10             	add    $0x10,%esp
}
801054aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
801054ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054b2:	5b                   	pop    %ebx
801054b3:	5e                   	pop    %esi
801054b4:	5f                   	pop    %edi
801054b5:	5d                   	pop    %ebp
801054b6:	c3                   	ret    
801054b7:	89 f6                	mov    %esi,%esi
801054b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
801054c0:	83 ec 0c             	sub    $0xc,%esp
801054c3:	53                   	push   %ebx
801054c4:	e8 27 c4 ff ff       	call   801018f0 <iunlockput>
    end_op();
801054c9:	e8 e2 d6 ff ff       	call   80102bb0 <end_op>
    return -1;
801054ce:	83 c4 10             	add    $0x10,%esp
801054d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054d6:	eb 92                	jmp    8010546a <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
801054d8:	e8 d3 d6 ff ff       	call   80102bb0 <end_op>
    return -1;
801054dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054e2:	eb 86                	jmp    8010546a <sys_link+0xda>
801054e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801054ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801054f0 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	57                   	push   %edi
801054f4:	56                   	push   %esi
801054f5:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801054f6:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
801054f9:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801054fc:	50                   	push   %eax
801054fd:	6a 00                	push   $0x0
801054ff:	e8 fc f9 ff ff       	call   80104f00 <argstr>
80105504:	83 c4 10             	add    $0x10,%esp
80105507:	85 c0                	test   %eax,%eax
80105509:	0f 88 82 01 00 00    	js     80105691 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
8010550f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80105512:	e8 29 d6 ff ff       	call   80102b40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105517:	83 ec 08             	sub    $0x8,%esp
8010551a:	53                   	push   %ebx
8010551b:	ff 75 c0             	pushl  -0x40(%ebp)
8010551e:	e8 ad c9 ff ff       	call   80101ed0 <nameiparent>
80105523:	83 c4 10             	add    $0x10,%esp
80105526:	85 c0                	test   %eax,%eax
80105528:	89 45 b4             	mov    %eax,-0x4c(%ebp)
8010552b:	0f 84 6a 01 00 00    	je     8010569b <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80105531:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80105534:	83 ec 0c             	sub    $0xc,%esp
80105537:	56                   	push   %esi
80105538:	e8 23 c1 ff ff       	call   80101660 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010553d:	58                   	pop    %eax
8010553e:	5a                   	pop    %edx
8010553f:	68 00 82 10 80       	push   $0x80108200
80105544:	53                   	push   %ebx
80105545:	e8 26 c6 ff ff       	call   80101b70 <namecmp>
8010554a:	83 c4 10             	add    $0x10,%esp
8010554d:	85 c0                	test   %eax,%eax
8010554f:	0f 84 fc 00 00 00    	je     80105651 <sys_unlink+0x161>
80105555:	83 ec 08             	sub    $0x8,%esp
80105558:	68 ff 81 10 80       	push   $0x801081ff
8010555d:	53                   	push   %ebx
8010555e:	e8 0d c6 ff ff       	call   80101b70 <namecmp>
80105563:	83 c4 10             	add    $0x10,%esp
80105566:	85 c0                	test   %eax,%eax
80105568:	0f 84 e3 00 00 00    	je     80105651 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010556e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105571:	83 ec 04             	sub    $0x4,%esp
80105574:	50                   	push   %eax
80105575:	53                   	push   %ebx
80105576:	56                   	push   %esi
80105577:	e8 14 c6 ff ff       	call   80101b90 <dirlookup>
8010557c:	83 c4 10             	add    $0x10,%esp
8010557f:	85 c0                	test   %eax,%eax
80105581:	89 c3                	mov    %eax,%ebx
80105583:	0f 84 c8 00 00 00    	je     80105651 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
80105589:	83 ec 0c             	sub    $0xc,%esp
8010558c:	50                   	push   %eax
8010558d:	e8 ce c0 ff ff       	call   80101660 <ilock>

  if(ip->nlink < 1)
80105592:	83 c4 10             	add    $0x10,%esp
80105595:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010559a:	0f 8e 24 01 00 00    	jle    801056c4 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801055a0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055a5:	8d 75 d8             	lea    -0x28(%ebp),%esi
801055a8:	74 66                	je     80105610 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801055aa:	83 ec 04             	sub    $0x4,%esp
801055ad:	6a 10                	push   $0x10
801055af:	6a 00                	push   $0x0
801055b1:	56                   	push   %esi
801055b2:	e8 89 f5 ff ff       	call   80104b40 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801055b7:	6a 10                	push   $0x10
801055b9:	ff 75 c4             	pushl  -0x3c(%ebp)
801055bc:	56                   	push   %esi
801055bd:	ff 75 b4             	pushl  -0x4c(%ebp)
801055c0:	e8 7b c4 ff ff       	call   80101a40 <writei>
801055c5:	83 c4 20             	add    $0x20,%esp
801055c8:	83 f8 10             	cmp    $0x10,%eax
801055cb:	0f 85 e6 00 00 00    	jne    801056b7 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801055d1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055d6:	0f 84 9c 00 00 00    	je     80105678 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
801055dc:	83 ec 0c             	sub    $0xc,%esp
801055df:	ff 75 b4             	pushl  -0x4c(%ebp)
801055e2:	e8 09 c3 ff ff       	call   801018f0 <iunlockput>

  ip->nlink--;
801055e7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801055ec:	89 1c 24             	mov    %ebx,(%esp)
801055ef:	e8 bc bf ff ff       	call   801015b0 <iupdate>
  iunlockput(ip);
801055f4:	89 1c 24             	mov    %ebx,(%esp)
801055f7:	e8 f4 c2 ff ff       	call   801018f0 <iunlockput>

  end_op();
801055fc:	e8 af d5 ff ff       	call   80102bb0 <end_op>

  return 0;
80105601:	83 c4 10             	add    $0x10,%esp
80105604:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105606:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105609:	5b                   	pop    %ebx
8010560a:	5e                   	pop    %esi
8010560b:	5f                   	pop    %edi
8010560c:	5d                   	pop    %ebp
8010560d:	c3                   	ret    
8010560e:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105610:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105614:	76 94                	jbe    801055aa <sys_unlink+0xba>
80105616:	bf 20 00 00 00       	mov    $0x20,%edi
8010561b:	eb 0f                	jmp    8010562c <sys_unlink+0x13c>
8010561d:	8d 76 00             	lea    0x0(%esi),%esi
80105620:	83 c7 10             	add    $0x10,%edi
80105623:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105626:	0f 83 7e ff ff ff    	jae    801055aa <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010562c:	6a 10                	push   $0x10
8010562e:	57                   	push   %edi
8010562f:	56                   	push   %esi
80105630:	53                   	push   %ebx
80105631:	e8 0a c3 ff ff       	call   80101940 <readi>
80105636:	83 c4 10             	add    $0x10,%esp
80105639:	83 f8 10             	cmp    $0x10,%eax
8010563c:	75 6c                	jne    801056aa <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010563e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105643:	74 db                	je     80105620 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80105645:	83 ec 0c             	sub    $0xc,%esp
80105648:	53                   	push   %ebx
80105649:	e8 a2 c2 ff ff       	call   801018f0 <iunlockput>
    goto bad;
8010564e:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105651:	83 ec 0c             	sub    $0xc,%esp
80105654:	ff 75 b4             	pushl  -0x4c(%ebp)
80105657:	e8 94 c2 ff ff       	call   801018f0 <iunlockput>
  end_op();
8010565c:	e8 4f d5 ff ff       	call   80102bb0 <end_op>
  return -1;
80105661:	83 c4 10             	add    $0x10,%esp
}
80105664:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80105667:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010566c:	5b                   	pop    %ebx
8010566d:	5e                   	pop    %esi
8010566e:	5f                   	pop    %edi
8010566f:	5d                   	pop    %ebp
80105670:	c3                   	ret    
80105671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80105678:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
8010567b:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
8010567e:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105683:	50                   	push   %eax
80105684:	e8 27 bf ff ff       	call   801015b0 <iupdate>
80105689:	83 c4 10             	add    $0x10,%esp
8010568c:	e9 4b ff ff ff       	jmp    801055dc <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80105691:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105696:	e9 6b ff ff ff       	jmp    80105606 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
8010569b:	e8 10 d5 ff ff       	call   80102bb0 <end_op>
    return -1;
801056a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056a5:	e9 5c ff ff ff       	jmp    80105606 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
801056aa:	83 ec 0c             	sub    $0xc,%esp
801056ad:	68 24 82 10 80       	push   $0x80108224
801056b2:	e8 b9 ac ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
801056b7:	83 ec 0c             	sub    $0xc,%esp
801056ba:	68 36 82 10 80       	push   $0x80108236
801056bf:	e8 ac ac ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
801056c4:	83 ec 0c             	sub    $0xc,%esp
801056c7:	68 12 82 10 80       	push   $0x80108212
801056cc:	e8 9f ac ff ff       	call   80100370 <panic>
801056d1:	eb 0d                	jmp    801056e0 <sys_open>
801056d3:	90                   	nop
801056d4:	90                   	nop
801056d5:	90                   	nop
801056d6:	90                   	nop
801056d7:	90                   	nop
801056d8:	90                   	nop
801056d9:	90                   	nop
801056da:	90                   	nop
801056db:	90                   	nop
801056dc:	90                   	nop
801056dd:	90                   	nop
801056de:	90                   	nop
801056df:	90                   	nop

801056e0 <sys_open>:
  return ip;
}

int
sys_open(void)
{
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
801056e3:	57                   	push   %edi
801056e4:	56                   	push   %esi
801056e5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801056e6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
801056e9:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801056ec:	50                   	push   %eax
801056ed:	6a 00                	push   $0x0
801056ef:	e8 0c f8 ff ff       	call   80104f00 <argstr>
801056f4:	83 c4 10             	add    $0x10,%esp
801056f7:	85 c0                	test   %eax,%eax
801056f9:	0f 88 9e 00 00 00    	js     8010579d <sys_open+0xbd>
801056ff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105702:	83 ec 08             	sub    $0x8,%esp
80105705:	50                   	push   %eax
80105706:	6a 01                	push   $0x1
80105708:	e8 43 f7 ff ff       	call   80104e50 <argint>
8010570d:	83 c4 10             	add    $0x10,%esp
80105710:	85 c0                	test   %eax,%eax
80105712:	0f 88 85 00 00 00    	js     8010579d <sys_open+0xbd>
    return -1;

  begin_op();
80105718:	e8 23 d4 ff ff       	call   80102b40 <begin_op>

  if(omode & O_CREATE){
8010571d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105721:	0f 85 89 00 00 00    	jne    801057b0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105727:	83 ec 0c             	sub    $0xc,%esp
8010572a:	ff 75 e0             	pushl  -0x20(%ebp)
8010572d:	e8 7e c7 ff ff       	call   80101eb0 <namei>
80105732:	83 c4 10             	add    $0x10,%esp
80105735:	85 c0                	test   %eax,%eax
80105737:	89 c6                	mov    %eax,%esi
80105739:	0f 84 8e 00 00 00    	je     801057cd <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
8010573f:	83 ec 0c             	sub    $0xc,%esp
80105742:	50                   	push   %eax
80105743:	e8 18 bf ff ff       	call   80101660 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105748:	83 c4 10             	add    $0x10,%esp
8010574b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105750:	0f 84 d2 00 00 00    	je     80105828 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105756:	e8 15 b6 ff ff       	call   80100d70 <filealloc>
8010575b:	85 c0                	test   %eax,%eax
8010575d:	89 c7                	mov    %eax,%edi
8010575f:	74 2b                	je     8010578c <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105761:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105763:	e8 88 e0 ff ff       	call   801037f0 <myproc>
80105768:	90                   	nop
80105769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105770:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105774:	85 d2                	test   %edx,%edx
80105776:	74 68                	je     801057e0 <sys_open+0x100>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105778:	83 c3 01             	add    $0x1,%ebx
8010577b:	83 fb 10             	cmp    $0x10,%ebx
8010577e:	75 f0                	jne    80105770 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105780:	83 ec 0c             	sub    $0xc,%esp
80105783:	57                   	push   %edi
80105784:	e8 a7 b6 ff ff       	call   80100e30 <fileclose>
80105789:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010578c:	83 ec 0c             	sub    $0xc,%esp
8010578f:	56                   	push   %esi
80105790:	e8 5b c1 ff ff       	call   801018f0 <iunlockput>
    end_op();
80105795:	e8 16 d4 ff ff       	call   80102bb0 <end_op>
    return -1;
8010579a:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
8010579d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
801057a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801057a5:	5b                   	pop    %ebx
801057a6:	5e                   	pop    %esi
801057a7:	5f                   	pop    %edi
801057a8:	5d                   	pop    %ebp
801057a9:	c3                   	ret    
801057aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801057b0:	83 ec 0c             	sub    $0xc,%esp
801057b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801057b6:	31 c9                	xor    %ecx,%ecx
801057b8:	6a 00                	push   $0x0
801057ba:	ba 02 00 00 00       	mov    $0x2,%edx
801057bf:	e8 dc f7 ff ff       	call   80104fa0 <create>
    if(ip == 0){
801057c4:	83 c4 10             	add    $0x10,%esp
801057c7:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801057c9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801057cb:	75 89                	jne    80105756 <sys_open+0x76>
      end_op();
801057cd:	e8 de d3 ff ff       	call   80102bb0 <end_op>
      return -1;
801057d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057d7:	eb 43                	jmp    8010581c <sys_open+0x13c>
801057d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801057e0:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801057e3:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801057e7:	56                   	push   %esi
801057e8:	e8 53 bf ff ff       	call   80101740 <iunlock>
  end_op();
801057ed:	e8 be d3 ff ff       	call   80102bb0 <end_op>

  f->type = FD_INODE;
801057f2:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801057f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801057fb:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
801057fe:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105801:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105808:	89 d0                	mov    %edx,%eax
8010580a:	83 e0 01             	and    $0x1,%eax
8010580d:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105810:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105813:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105816:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
8010581a:	89 d8                	mov    %ebx,%eax
}
8010581c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010581f:	5b                   	pop    %ebx
80105820:	5e                   	pop    %esi
80105821:	5f                   	pop    %edi
80105822:	5d                   	pop    %ebp
80105823:	c3                   	ret    
80105824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105828:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010582b:	85 c9                	test   %ecx,%ecx
8010582d:	0f 84 23 ff ff ff    	je     80105756 <sys_open+0x76>
80105833:	e9 54 ff ff ff       	jmp    8010578c <sys_open+0xac>
80105838:	90                   	nop
80105839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105840 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105846:	e8 f5 d2 ff ff       	call   80102b40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010584b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010584e:	83 ec 08             	sub    $0x8,%esp
80105851:	50                   	push   %eax
80105852:	6a 00                	push   $0x0
80105854:	e8 a7 f6 ff ff       	call   80104f00 <argstr>
80105859:	83 c4 10             	add    $0x10,%esp
8010585c:	85 c0                	test   %eax,%eax
8010585e:	78 30                	js     80105890 <sys_mkdir+0x50>
80105860:	83 ec 0c             	sub    $0xc,%esp
80105863:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105866:	31 c9                	xor    %ecx,%ecx
80105868:	6a 00                	push   $0x0
8010586a:	ba 01 00 00 00       	mov    $0x1,%edx
8010586f:	e8 2c f7 ff ff       	call   80104fa0 <create>
80105874:	83 c4 10             	add    $0x10,%esp
80105877:	85 c0                	test   %eax,%eax
80105879:	74 15                	je     80105890 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010587b:	83 ec 0c             	sub    $0xc,%esp
8010587e:	50                   	push   %eax
8010587f:	e8 6c c0 ff ff       	call   801018f0 <iunlockput>
  end_op();
80105884:	e8 27 d3 ff ff       	call   80102bb0 <end_op>
  return 0;
80105889:	83 c4 10             	add    $0x10,%esp
8010588c:	31 c0                	xor    %eax,%eax
}
8010588e:	c9                   	leave  
8010588f:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105890:	e8 1b d3 ff ff       	call   80102bb0 <end_op>
    return -1;
80105895:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010589a:	c9                   	leave  
8010589b:	c3                   	ret    
8010589c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058a0 <sys_mknod>:

int
sys_mknod(void)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801058a6:	e8 95 d2 ff ff       	call   80102b40 <begin_op>
  if((argstr(0, &path)) < 0 ||
801058ab:	8d 45 ec             	lea    -0x14(%ebp),%eax
801058ae:	83 ec 08             	sub    $0x8,%esp
801058b1:	50                   	push   %eax
801058b2:	6a 00                	push   $0x0
801058b4:	e8 47 f6 ff ff       	call   80104f00 <argstr>
801058b9:	83 c4 10             	add    $0x10,%esp
801058bc:	85 c0                	test   %eax,%eax
801058be:	78 60                	js     80105920 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801058c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058c3:	83 ec 08             	sub    $0x8,%esp
801058c6:	50                   	push   %eax
801058c7:	6a 01                	push   $0x1
801058c9:	e8 82 f5 ff ff       	call   80104e50 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
801058ce:	83 c4 10             	add    $0x10,%esp
801058d1:	85 c0                	test   %eax,%eax
801058d3:	78 4b                	js     80105920 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801058d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058d8:	83 ec 08             	sub    $0x8,%esp
801058db:	50                   	push   %eax
801058dc:	6a 02                	push   $0x2
801058de:	e8 6d f5 ff ff       	call   80104e50 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801058e3:	83 c4 10             	add    $0x10,%esp
801058e6:	85 c0                	test   %eax,%eax
801058e8:	78 36                	js     80105920 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801058ea:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801058ee:	83 ec 0c             	sub    $0xc,%esp
801058f1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801058f5:	ba 03 00 00 00       	mov    $0x3,%edx
801058fa:	50                   	push   %eax
801058fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801058fe:	e8 9d f6 ff ff       	call   80104fa0 <create>
80105903:	83 c4 10             	add    $0x10,%esp
80105906:	85 c0                	test   %eax,%eax
80105908:	74 16                	je     80105920 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010590a:	83 ec 0c             	sub    $0xc,%esp
8010590d:	50                   	push   %eax
8010590e:	e8 dd bf ff ff       	call   801018f0 <iunlockput>
  end_op();
80105913:	e8 98 d2 ff ff       	call   80102bb0 <end_op>
  return 0;
80105918:	83 c4 10             	add    $0x10,%esp
8010591b:	31 c0                	xor    %eax,%eax
}
8010591d:	c9                   	leave  
8010591e:	c3                   	ret    
8010591f:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105920:	e8 8b d2 ff ff       	call   80102bb0 <end_op>
    return -1;
80105925:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010592a:	c9                   	leave  
8010592b:	c3                   	ret    
8010592c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105930 <sys_chdir>:

int
sys_chdir(void)
{
80105930:	55                   	push   %ebp
80105931:	89 e5                	mov    %esp,%ebp
80105933:	56                   	push   %esi
80105934:	53                   	push   %ebx
80105935:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105938:	e8 b3 de ff ff       	call   801037f0 <myproc>
8010593d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010593f:	e8 fc d1 ff ff       	call   80102b40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105944:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105947:	83 ec 08             	sub    $0x8,%esp
8010594a:	50                   	push   %eax
8010594b:	6a 00                	push   $0x0
8010594d:	e8 ae f5 ff ff       	call   80104f00 <argstr>
80105952:	83 c4 10             	add    $0x10,%esp
80105955:	85 c0                	test   %eax,%eax
80105957:	78 77                	js     801059d0 <sys_chdir+0xa0>
80105959:	83 ec 0c             	sub    $0xc,%esp
8010595c:	ff 75 f4             	pushl  -0xc(%ebp)
8010595f:	e8 4c c5 ff ff       	call   80101eb0 <namei>
80105964:	83 c4 10             	add    $0x10,%esp
80105967:	85 c0                	test   %eax,%eax
80105969:	89 c3                	mov    %eax,%ebx
8010596b:	74 63                	je     801059d0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010596d:	83 ec 0c             	sub    $0xc,%esp
80105970:	50                   	push   %eax
80105971:	e8 ea bc ff ff       	call   80101660 <ilock>
  if(ip->type != T_DIR){
80105976:	83 c4 10             	add    $0x10,%esp
80105979:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010597e:	75 30                	jne    801059b0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105980:	83 ec 0c             	sub    $0xc,%esp
80105983:	53                   	push   %ebx
80105984:	e8 b7 bd ff ff       	call   80101740 <iunlock>
  iput(curproc->cwd);
80105989:	58                   	pop    %eax
8010598a:	ff 76 68             	pushl  0x68(%esi)
8010598d:	e8 fe bd ff ff       	call   80101790 <iput>
  end_op();
80105992:	e8 19 d2 ff ff       	call   80102bb0 <end_op>
  curproc->cwd = ip;
80105997:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010599a:	83 c4 10             	add    $0x10,%esp
8010599d:	31 c0                	xor    %eax,%eax
}
8010599f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801059a2:	5b                   	pop    %ebx
801059a3:	5e                   	pop    %esi
801059a4:	5d                   	pop    %ebp
801059a5:	c3                   	ret    
801059a6:	8d 76 00             	lea    0x0(%esi),%esi
801059a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
801059b0:	83 ec 0c             	sub    $0xc,%esp
801059b3:	53                   	push   %ebx
801059b4:	e8 37 bf ff ff       	call   801018f0 <iunlockput>
    end_op();
801059b9:	e8 f2 d1 ff ff       	call   80102bb0 <end_op>
    return -1;
801059be:	83 c4 10             	add    $0x10,%esp
801059c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059c6:	eb d7                	jmp    8010599f <sys_chdir+0x6f>
801059c8:	90                   	nop
801059c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
801059d0:	e8 db d1 ff ff       	call   80102bb0 <end_op>
    return -1;
801059d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059da:	eb c3                	jmp    8010599f <sys_chdir+0x6f>
801059dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059e0 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	57                   	push   %edi
801059e4:	56                   	push   %esi
801059e5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801059e6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
801059ec:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801059f2:	50                   	push   %eax
801059f3:	6a 00                	push   $0x0
801059f5:	e8 06 f5 ff ff       	call   80104f00 <argstr>
801059fa:	83 c4 10             	add    $0x10,%esp
801059fd:	85 c0                	test   %eax,%eax
801059ff:	78 7f                	js     80105a80 <sys_exec+0xa0>
80105a01:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105a07:	83 ec 08             	sub    $0x8,%esp
80105a0a:	50                   	push   %eax
80105a0b:	6a 01                	push   $0x1
80105a0d:	e8 3e f4 ff ff       	call   80104e50 <argint>
80105a12:	83 c4 10             	add    $0x10,%esp
80105a15:	85 c0                	test   %eax,%eax
80105a17:	78 67                	js     80105a80 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105a19:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105a1f:	83 ec 04             	sub    $0x4,%esp
80105a22:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105a28:	68 80 00 00 00       	push   $0x80
80105a2d:	6a 00                	push   $0x0
80105a2f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105a35:	50                   	push   %eax
80105a36:	31 db                	xor    %ebx,%ebx
80105a38:	e8 03 f1 ff ff       	call   80104b40 <memset>
80105a3d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105a40:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105a46:	83 ec 08             	sub    $0x8,%esp
80105a49:	57                   	push   %edi
80105a4a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80105a4d:	50                   	push   %eax
80105a4e:	e8 5d f3 ff ff       	call   80104db0 <fetchint>
80105a53:	83 c4 10             	add    $0x10,%esp
80105a56:	85 c0                	test   %eax,%eax
80105a58:	78 26                	js     80105a80 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
80105a5a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105a60:	85 c0                	test   %eax,%eax
80105a62:	74 2c                	je     80105a90 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105a64:	83 ec 08             	sub    $0x8,%esp
80105a67:	56                   	push   %esi
80105a68:	50                   	push   %eax
80105a69:	e8 82 f3 ff ff       	call   80104df0 <fetchstr>
80105a6e:	83 c4 10             	add    $0x10,%esp
80105a71:	85 c0                	test   %eax,%eax
80105a73:	78 0b                	js     80105a80 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105a75:	83 c3 01             	add    $0x1,%ebx
80105a78:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105a7b:	83 fb 20             	cmp    $0x20,%ebx
80105a7e:	75 c0                	jne    80105a40 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105a80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105a83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105a88:	5b                   	pop    %ebx
80105a89:	5e                   	pop    %esi
80105a8a:	5f                   	pop    %edi
80105a8b:	5d                   	pop    %ebp
80105a8c:	c3                   	ret    
80105a8d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105a90:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105a96:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105a99:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105aa0:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105aa4:	50                   	push   %eax
80105aa5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105aab:	e8 40 af ff ff       	call   801009f0 <exec>
80105ab0:	83 c4 10             	add    $0x10,%esp
}
80105ab3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ab6:	5b                   	pop    %ebx
80105ab7:	5e                   	pop    %esi
80105ab8:	5f                   	pop    %edi
80105ab9:	5d                   	pop    %ebp
80105aba:	c3                   	ret    
80105abb:	90                   	nop
80105abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ac0 <sys_pipe>:

int
sys_pipe(void)
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	57                   	push   %edi
80105ac4:	56                   	push   %esi
80105ac5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105ac6:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
80105ac9:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105acc:	6a 08                	push   $0x8
80105ace:	50                   	push   %eax
80105acf:	6a 00                	push   $0x0
80105ad1:	e8 ca f3 ff ff       	call   80104ea0 <argptr>
80105ad6:	83 c4 10             	add    $0x10,%esp
80105ad9:	85 c0                	test   %eax,%eax
80105adb:	78 4a                	js     80105b27 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105add:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ae0:	83 ec 08             	sub    $0x8,%esp
80105ae3:	50                   	push   %eax
80105ae4:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105ae7:	50                   	push   %eax
80105ae8:	e8 f3 d6 ff ff       	call   801031e0 <pipealloc>
80105aed:	83 c4 10             	add    $0x10,%esp
80105af0:	85 c0                	test   %eax,%eax
80105af2:	78 33                	js     80105b27 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105af4:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105af6:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105af9:	e8 f2 dc ff ff       	call   801037f0 <myproc>
80105afe:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105b00:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105b04:	85 f6                	test   %esi,%esi
80105b06:	74 30                	je     80105b38 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105b08:	83 c3 01             	add    $0x1,%ebx
80105b0b:	83 fb 10             	cmp    $0x10,%ebx
80105b0e:	75 f0                	jne    80105b00 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105b10:	83 ec 0c             	sub    $0xc,%esp
80105b13:	ff 75 e0             	pushl  -0x20(%ebp)
80105b16:	e8 15 b3 ff ff       	call   80100e30 <fileclose>
    fileclose(wf);
80105b1b:	58                   	pop    %eax
80105b1c:	ff 75 e4             	pushl  -0x1c(%ebp)
80105b1f:	e8 0c b3 ff ff       	call   80100e30 <fileclose>
    return -1;
80105b24:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105b27:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
80105b2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105b2f:	5b                   	pop    %ebx
80105b30:	5e                   	pop    %esi
80105b31:	5f                   	pop    %edi
80105b32:	5d                   	pop    %ebp
80105b33:	c3                   	ret    
80105b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105b38:	8d 73 08             	lea    0x8(%ebx),%esi
80105b3b:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105b3f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105b42:	e8 a9 dc ff ff       	call   801037f0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
80105b47:	31 d2                	xor    %edx,%edx
80105b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105b50:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105b54:	85 c9                	test   %ecx,%ecx
80105b56:	74 18                	je     80105b70 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105b58:	83 c2 01             	add    $0x1,%edx
80105b5b:	83 fa 10             	cmp    $0x10,%edx
80105b5e:	75 f0                	jne    80105b50 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105b60:	e8 8b dc ff ff       	call   801037f0 <myproc>
80105b65:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105b6c:	00 
80105b6d:	eb a1                	jmp    80105b10 <sys_pipe+0x50>
80105b6f:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105b70:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105b74:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b77:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105b79:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b7c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
80105b7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105b82:	31 c0                	xor    %eax,%eax
}
80105b84:	5b                   	pop    %ebx
80105b85:	5e                   	pop    %esi
80105b86:	5f                   	pop    %edi
80105b87:	5d                   	pop    %ebp
80105b88:	c3                   	ret    
80105b89:	66 90                	xchg   %ax,%ax
80105b8b:	66 90                	xchg   %ax,%ax
80105b8d:	66 90                	xchg   %ax,%ax
80105b8f:	90                   	nop

80105b90 <sys_fork>:
  return &pgtab[PTX(va)];
}

int
sys_fork(void)
{
80105b90:	55                   	push   %ebp
80105b91:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105b93:	5d                   	pop    %ebp
}

int
sys_fork(void)
{
  return fork();
80105b94:	e9 f7 dd ff ff       	jmp    80103990 <fork>
80105b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ba0 <sys_exit>:
}

int
sys_exit(void)
{
80105ba0:	55                   	push   %ebp
80105ba1:	89 e5                	mov    %esp,%ebp
80105ba3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105ba6:	e8 e5 e5 ff ff       	call   80104190 <exit>
  return 0;  // not reached
}
80105bab:	31 c0                	xor    %eax,%eax
80105bad:	c9                   	leave  
80105bae:	c3                   	ret    
80105baf:	90                   	nop

80105bb0 <sys_wait>:

int
sys_wait(void)
{
80105bb0:	55                   	push   %ebp
80105bb1:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105bb3:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105bb4:	e9 67 e8 ff ff       	jmp    80104420 <wait>
80105bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105bc0 <sys_kill>:
}

int
sys_kill(void)
{
80105bc0:	55                   	push   %ebp
80105bc1:	89 e5                	mov    %esp,%ebp
80105bc3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105bc6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bc9:	50                   	push   %eax
80105bca:	6a 00                	push   $0x0
80105bcc:	e8 7f f2 ff ff       	call   80104e50 <argint>
80105bd1:	83 c4 10             	add    $0x10,%esp
80105bd4:	85 c0                	test   %eax,%eax
80105bd6:	78 18                	js     80105bf0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105bd8:	83 ec 0c             	sub    $0xc,%esp
80105bdb:	ff 75 f4             	pushl  -0xc(%ebp)
80105bde:	e8 0d ea ff ff       	call   801045f0 <kill>
80105be3:	83 c4 10             	add    $0x10,%esp
}
80105be6:	c9                   	leave  
80105be7:	c3                   	ret    
80105be8:	90                   	nop
80105be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105bf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105bf5:	c9                   	leave  
80105bf6:	c3                   	ret    
80105bf7:	89 f6                	mov    %esi,%esi
80105bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c00 <sys_getpid>:

int
sys_getpid(void)
{
80105c00:	55                   	push   %ebp
80105c01:	89 e5                	mov    %esp,%ebp
80105c03:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105c06:	e8 e5 db ff ff       	call   801037f0 <myproc>
80105c0b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105c0e:	c9                   	leave  
80105c0f:	c3                   	ret    

80105c10 <sys_sbrk>:

int
sys_sbrk(void)
{
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
80105c13:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105c14:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
80105c17:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105c1a:	50                   	push   %eax
80105c1b:	6a 00                	push   $0x0
80105c1d:	e8 2e f2 ff ff       	call   80104e50 <argint>
80105c22:	83 c4 10             	add    $0x10,%esp
80105c25:	85 c0                	test   %eax,%eax
80105c27:	78 27                	js     80105c50 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105c29:	e8 c2 db ff ff       	call   801037f0 <myproc>
  if(growproc(n) < 0)
80105c2e:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105c31:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105c33:	ff 75 f4             	pushl  -0xc(%ebp)
80105c36:	e8 d5 dc ff ff       	call   80103910 <growproc>
80105c3b:	83 c4 10             	add    $0x10,%esp
80105c3e:	85 c0                	test   %eax,%eax
80105c40:	78 0e                	js     80105c50 <sys_sbrk+0x40>
    return -1;
  return addr;
80105c42:	89 d8                	mov    %ebx,%eax
}
80105c44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c47:	c9                   	leave  
80105c48:	c3                   	ret    
80105c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105c50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c55:	eb ed                	jmp    80105c44 <sys_sbrk+0x34>
80105c57:	89 f6                	mov    %esi,%esi
80105c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c60 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105c64:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
80105c67:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105c6a:	50                   	push   %eax
80105c6b:	6a 00                	push   $0x0
80105c6d:	e8 de f1 ff ff       	call   80104e50 <argint>
80105c72:	83 c4 10             	add    $0x10,%esp
80105c75:	85 c0                	test   %eax,%eax
80105c77:	0f 88 8a 00 00 00    	js     80105d07 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105c7d:	83 ec 0c             	sub    $0xc,%esp
80105c80:	68 40 6e 11 80       	push   $0x80116e40
80105c85:	e8 b6 ed ff ff       	call   80104a40 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105c8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c8d:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105c90:	8b 1d 80 76 11 80    	mov    0x80117680,%ebx
  while(ticks - ticks0 < n){
80105c96:	85 d2                	test   %edx,%edx
80105c98:	75 27                	jne    80105cc1 <sys_sleep+0x61>
80105c9a:	eb 54                	jmp    80105cf0 <sys_sleep+0x90>
80105c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105ca0:	83 ec 08             	sub    $0x8,%esp
80105ca3:	68 40 6e 11 80       	push   $0x80116e40
80105ca8:	68 80 76 11 80       	push   $0x80117680
80105cad:	e8 ae e6 ff ff       	call   80104360 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105cb2:	a1 80 76 11 80       	mov    0x80117680,%eax
80105cb7:	83 c4 10             	add    $0x10,%esp
80105cba:	29 d8                	sub    %ebx,%eax
80105cbc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105cbf:	73 2f                	jae    80105cf0 <sys_sleep+0x90>
    if(myproc()->killed){
80105cc1:	e8 2a db ff ff       	call   801037f0 <myproc>
80105cc6:	8b 40 24             	mov    0x24(%eax),%eax
80105cc9:	85 c0                	test   %eax,%eax
80105ccb:	74 d3                	je     80105ca0 <sys_sleep+0x40>
      release(&tickslock);
80105ccd:	83 ec 0c             	sub    $0xc,%esp
80105cd0:	68 40 6e 11 80       	push   $0x80116e40
80105cd5:	e8 16 ee ff ff       	call   80104af0 <release>
      return -1;
80105cda:	83 c4 10             	add    $0x10,%esp
80105cdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80105ce2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ce5:	c9                   	leave  
80105ce6:	c3                   	ret    
80105ce7:	89 f6                	mov    %esi,%esi
80105ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105cf0:	83 ec 0c             	sub    $0xc,%esp
80105cf3:	68 40 6e 11 80       	push   $0x80116e40
80105cf8:	e8 f3 ed ff ff       	call   80104af0 <release>
  return 0;
80105cfd:	83 c4 10             	add    $0x10,%esp
80105d00:	31 c0                	xor    %eax,%eax
}
80105d02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d05:	c9                   	leave  
80105d06:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
80105d07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d0c:	eb d4                	jmp    80105ce2 <sys_sleep+0x82>
80105d0e:	66 90                	xchg   %ax,%ax

80105d10 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105d10:	55                   	push   %ebp
80105d11:	89 e5                	mov    %esp,%ebp
80105d13:	53                   	push   %ebx
80105d14:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105d17:	68 40 6e 11 80       	push   $0x80116e40
80105d1c:	e8 1f ed ff ff       	call   80104a40 <acquire>
  xticks = ticks;
80105d21:	8b 1d 80 76 11 80    	mov    0x80117680,%ebx
  release(&tickslock);
80105d27:	c7 04 24 40 6e 11 80 	movl   $0x80116e40,(%esp)
80105d2e:	e8 bd ed ff ff       	call   80104af0 <release>
  return xticks;
}
80105d33:	89 d8                	mov    %ebx,%eax
80105d35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d38:	c9                   	leave  
80105d39:	c3                   	ret    
80105d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105d40 <sys_info>:

//find number of currently USED processes in system
//LAB-1
int
sys_info(void)
{
80105d40:	55                   	push   %ebp
80105d41:	89 e5                	mov    %esp,%ebp
80105d43:	56                   	push   %esi
80105d44:	53                   	push   %ebx
        int n;
        argint(0, &n);
80105d45:	8d 45 f4             	lea    -0xc(%ebp),%eax

//find number of currently USED processes in system
//LAB-1
int
sys_info(void)
{
80105d48:	83 ec 18             	sub    $0x18,%esp
        int n;
        argint(0, &n);
80105d4b:	50                   	push   %eax
80105d4c:	6a 00                	push   $0x0
80105d4e:	e8 fd f0 ff ff       	call   80104e50 <argint>
  if(n == 1)
80105d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d56:	83 c4 10             	add    $0x10,%esp
80105d59:	83 f8 01             	cmp    $0x1,%eax
80105d5c:	74 7a                	je     80105dd8 <sys_info+0x98>
  {     int n;
        n = running_processes();        
        return n; 
  }
   //total number of system calls current process has made so far
  else if(n == 2)
80105d5e:	83 f8 02             	cmp    $0x2,%eax
80105d61:	74 7d                	je     80105de0 <sys_info+0xa0>
  {
      return myproc()->syscall_count;
  }
 //number of memory pages the current process is using.  
  else if(n == 3)
80105d63:	83 f8 03             	cmp    $0x3,%eax
80105d66:	0f 85 7e 00 00 00    	jne    80105dea <sys_info+0xaa>
80105d6c:	31 db                	xor    %ebx,%ebx
80105d6e:	31 f6                	xor    %esi,%esi
80105d70:	eb 2c                	jmp    80105d9e <sys_info+0x5e>
80105d72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      pde_t *pte;
      uint i;
      //traverse through page directory and see if a page entry is present.
      for(i = 0; i < myproc()->sz; i += PGSIZE){
        pte = walkpgdir(myproc()->pgdir, (void *) i, 0);
        if(*pte & PTE_P) count++;
80105d78:	89 d8                	mov    %ebx,%eax
80105d7a:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80105d80:	c1 e8 0c             	shr    $0xc,%eax
80105d83:	25 ff 03 00 00       	and    $0x3ff,%eax
80105d88:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
80105d8f:	83 e0 01             	and    $0x1,%eax
80105d92:	83 f8 01             	cmp    $0x1,%eax
80105d95:	83 de ff             	sbb    $0xffffffff,%esi
  {
      int count = 0;      
      pde_t *pte;
      uint i;
      //traverse through page directory and see if a page entry is present.
      for(i = 0; i < myproc()->sz; i += PGSIZE){
80105d98:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80105d9e:	e8 4d da ff ff       	call   801037f0 <myproc>
80105da3:	3b 18                	cmp    (%eax),%ebx
80105da5:	73 21                	jae    80105dc8 <sys_info+0x88>
        pte = walkpgdir(myproc()->pgdir, (void *) i, 0);
80105da7:	e8 44 da ff ff       	call   801037f0 <myproc>
{
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80105dac:	8b 40 04             	mov    0x4(%eax),%eax
80105daf:	89 da                	mov    %ebx,%edx
80105db1:	c1 ea 16             	shr    $0x16,%edx
80105db4:	8b 14 90             	mov    (%eax,%edx,4),%edx
80105db7:	f6 c2 01             	test   $0x1,%dl
80105dba:	75 bc                	jne    80105d78 <sys_info+0x38>
      pde_t *pte;
      uint i;
      //traverse through page directory and see if a page entry is present.
      for(i = 0; i < myproc()->sz; i += PGSIZE){
        pte = walkpgdir(myproc()->pgdir, (void *) i, 0);
        if(*pte & PTE_P) count++;
80105dbc:	a1 00 00 00 00       	mov    0x0,%eax
80105dc1:	0f 0b                	ud2    
80105dc3:	90                   	nop
80105dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105dc8:	89 f0                	mov    %esi,%eax
      }
      return count;
  }
  return -1;
}
80105dca:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105dcd:	5b                   	pop    %ebx
80105dce:	5e                   	pop    %esi
80105dcf:	5d                   	pop    %ebp
80105dd0:	c3                   	ret    
80105dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
        int n;
        argint(0, &n);
  if(n == 1)
  {     int n;
        n = running_processes();        
80105dd8:	e8 83 e9 ff ff       	call   80104760 <running_processes>
        return n; 
80105ddd:	eb eb                	jmp    80105dca <sys_info+0x8a>
80105ddf:	90                   	nop
  }
   //total number of system calls current process has made so far
  else if(n == 2)
  {
      return myproc()->syscall_count;
80105de0:	e8 0b da ff ff       	call   801037f0 <myproc>
80105de5:	8b 40 7c             	mov    0x7c(%eax),%eax
80105de8:	eb e0                	jmp    80105dca <sys_info+0x8a>
        pte = walkpgdir(myproc()->pgdir, (void *) i, 0);
        if(*pte & PTE_P) count++;
      }
      return count;
  }
  return -1;
80105dea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105def:	eb d9                	jmp    80105dca <sys_info+0x8a>
80105df1:	eb 0d                	jmp    80105e00 <sys_tickets>
80105df3:	90                   	nop
80105df4:	90                   	nop
80105df5:	90                   	nop
80105df6:	90                   	nop
80105df7:	90                   	nop
80105df8:	90                   	nop
80105df9:	90                   	nop
80105dfa:	90                   	nop
80105dfb:	90                   	nop
80105dfc:	90                   	nop
80105dfd:	90                   	nop
80105dfe:	90                   	nop
80105dff:	90                   	nop

80105e00 <sys_tickets>:
}

int
sys_tickets(void) { //LAB-2 allocation n number of tickets to current process
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	56                   	push   %esi
80105e04:	53                   	push   %ebx
int n;

if(argint(0, &n) < 0)
80105e05:	8d 45 f4             	lea    -0xc(%ebp),%eax
  }
  return -1;
}

int
sys_tickets(void) { //LAB-2 allocation n number of tickets to current process
80105e08:	83 ec 18             	sub    $0x18,%esp
int n;

if(argint(0, &n) < 0)
80105e0b:	50                   	push   %eax
80105e0c:	6a 00                	push   $0x0
80105e0e:	e8 3d f0 ff ff       	call   80104e50 <argint>
80105e13:	83 c4 10             	add    $0x10,%esp
80105e16:	85 c0                	test   %eax,%eax
80105e18:	78 46                	js     80105e60 <sys_tickets+0x60>
    return -1;
    myproc()->tickets = n;   
80105e1a:	e8 d1 d9 ff ff       	call   801037f0 <myproc>
80105e1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e22:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
    cprintf("proc:%d has been gaving %d tickets with name %s...\n",myproc()->pid,myproc()->tickets, myproc()->name);
80105e28:	e8 c3 d9 ff ff       	call   801037f0 <myproc>
80105e2d:	89 c3                	mov    %eax,%ebx
80105e2f:	e8 bc d9 ff ff       	call   801037f0 <myproc>
80105e34:	8b b0 80 00 00 00    	mov    0x80(%eax),%esi
80105e3a:	83 c3 6c             	add    $0x6c,%ebx
80105e3d:	e8 ae d9 ff ff       	call   801037f0 <myproc>
80105e42:	53                   	push   %ebx
80105e43:	56                   	push   %esi
80105e44:	ff 70 10             	pushl  0x10(%eax)
80105e47:	68 48 82 10 80       	push   $0x80108248
80105e4c:	e8 0f a8 ff ff       	call   80100660 <cprintf>

    return 0;
80105e51:	83 c4 10             	add    $0x10,%esp
80105e54:	31 c0                	xor    %eax,%eax
}
80105e56:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105e59:	5b                   	pop    %ebx
80105e5a:	5e                   	pop    %esi
80105e5b:	5d                   	pop    %ebp
80105e5c:	c3                   	ret    
80105e5d:	8d 76 00             	lea    0x0(%esi),%esi
int
sys_tickets(void) { //LAB-2 allocation n number of tickets to current process
int n;

if(argint(0, &n) < 0)
    return -1;
80105e60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e65:	eb ef                	jmp    80105e56 <sys_tickets+0x56>
80105e67:	89 f6                	mov    %esi,%esi
80105e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e70 <sys_clone>:
    cprintf("proc:%d has been gaving %d tickets with name %s...\n",myproc()->pid,myproc()->tickets, myproc()->name);

    return 0;
}
int
sys_clone(void) { //LAB-3
80105e70:	55                   	push   %ebp
80105e71:	89 e5                	mov    %esp,%ebp
80105e73:	83 ec 1c             	sub    $0x1c,%esp
    int size;
    void *stack;
 //   cprintf("entered sys_clone");
   if(argptr(0, (void*)&stack, sizeof(void*)) < 0 || argint(1, &size) < 0)
80105e76:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e79:	6a 04                	push   $0x4
80105e7b:	50                   	push   %eax
80105e7c:	6a 00                	push   $0x0
80105e7e:	e8 1d f0 ff ff       	call   80104ea0 <argptr>
80105e83:	83 c4 10             	add    $0x10,%esp
80105e86:	85 c0                	test   %eax,%eax
80105e88:	78 2e                	js     80105eb8 <sys_clone+0x48>
80105e8a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e8d:	83 ec 08             	sub    $0x8,%esp
80105e90:	50                   	push   %eax
80105e91:	6a 01                	push   $0x1
80105e93:	e8 b8 ef ff ff       	call   80104e50 <argint>
80105e98:	83 c4 10             	add    $0x10,%esp
80105e9b:	85 c0                	test   %eax,%eax
80105e9d:	78 19                	js     80105eb8 <sys_clone+0x48>
    {
        return -1;
    }

   return clone(stack,size);
80105e9f:	83 ec 08             	sub    $0x8,%esp
80105ea2:	ff 75 f0             	pushl  -0x10(%ebp)
80105ea5:	ff 75 f4             	pushl  -0xc(%ebp)
80105ea8:	e8 a3 dc ff ff       	call   80103b50 <clone>
80105ead:	83 c4 10             	add    $0x10,%esp
}
80105eb0:	c9                   	leave  
80105eb1:	c3                   	ret    
80105eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    int size;
    void *stack;
 //   cprintf("entered sys_clone");
   if(argptr(0, (void*)&stack, sizeof(void*)) < 0 || argint(1, &size) < 0)
    {
        return -1;
80105eb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

   return clone(stack,size);
}
80105ebd:	c9                   	leave  
80105ebe:	c3                   	ret    

80105ebf <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105ebf:	1e                   	push   %ds
  pushl %es
80105ec0:	06                   	push   %es
  pushl %fs
80105ec1:	0f a0                	push   %fs
  pushl %gs
80105ec3:	0f a8                	push   %gs
  pushal
80105ec5:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105ec6:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105eca:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105ecc:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105ece:	54                   	push   %esp
  call trap
80105ecf:	e8 ec 00 00 00       	call   80105fc0 <trap>
  addl $4, %esp
80105ed4:	83 c4 04             	add    $0x4,%esp

80105ed7 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105ed7:	61                   	popa   
  popl %gs
80105ed8:	0f a9                	pop    %gs
  popl %fs
80105eda:	0f a1                	pop    %fs
  popl %es
80105edc:	07                   	pop    %es
  popl %ds
80105edd:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105ede:	83 c4 08             	add    $0x8,%esp
  iret
80105ee1:	cf                   	iret   
80105ee2:	66 90                	xchg   %ax,%ax
80105ee4:	66 90                	xchg   %ax,%ax
80105ee6:	66 90                	xchg   %ax,%ax
80105ee8:	66 90                	xchg   %ax,%ax
80105eea:	66 90                	xchg   %ax,%ax
80105eec:	66 90                	xchg   %ax,%ax
80105eee:	66 90                	xchg   %ax,%ax

80105ef0 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105ef0:	31 c0                	xor    %eax,%eax
80105ef2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105ef8:	8b 14 85 18 b0 10 80 	mov    -0x7fef4fe8(,%eax,4),%edx
80105eff:	b9 08 00 00 00       	mov    $0x8,%ecx
80105f04:	c6 04 c5 84 6e 11 80 	movb   $0x0,-0x7fee917c(,%eax,8)
80105f0b:	00 
80105f0c:	66 89 0c c5 82 6e 11 	mov    %cx,-0x7fee917e(,%eax,8)
80105f13:	80 
80105f14:	c6 04 c5 85 6e 11 80 	movb   $0x8e,-0x7fee917b(,%eax,8)
80105f1b:	8e 
80105f1c:	66 89 14 c5 80 6e 11 	mov    %dx,-0x7fee9180(,%eax,8)
80105f23:	80 
80105f24:	c1 ea 10             	shr    $0x10,%edx
80105f27:	66 89 14 c5 86 6e 11 	mov    %dx,-0x7fee917a(,%eax,8)
80105f2e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105f2f:	83 c0 01             	add    $0x1,%eax
80105f32:	3d 00 01 00 00       	cmp    $0x100,%eax
80105f37:	75 bf                	jne    80105ef8 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105f39:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f3a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105f3f:	89 e5                	mov    %esp,%ebp
80105f41:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f44:	a1 18 b1 10 80       	mov    0x8010b118,%eax

  initlock(&tickslock, "time");
80105f49:	68 7c 82 10 80       	push   $0x8010827c
80105f4e:	68 40 6e 11 80       	push   $0x80116e40
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f53:	66 89 15 82 70 11 80 	mov    %dx,0x80117082
80105f5a:	c6 05 84 70 11 80 00 	movb   $0x0,0x80117084
80105f61:	66 a3 80 70 11 80    	mov    %ax,0x80117080
80105f67:	c1 e8 10             	shr    $0x10,%eax
80105f6a:	c6 05 85 70 11 80 ef 	movb   $0xef,0x80117085
80105f71:	66 a3 86 70 11 80    	mov    %ax,0x80117086

  initlock(&tickslock, "time");
80105f77:	e8 64 e9 ff ff       	call   801048e0 <initlock>
}
80105f7c:	83 c4 10             	add    $0x10,%esp
80105f7f:	c9                   	leave  
80105f80:	c3                   	ret    
80105f81:	eb 0d                	jmp    80105f90 <idtinit>
80105f83:	90                   	nop
80105f84:	90                   	nop
80105f85:	90                   	nop
80105f86:	90                   	nop
80105f87:	90                   	nop
80105f88:	90                   	nop
80105f89:	90                   	nop
80105f8a:	90                   	nop
80105f8b:	90                   	nop
80105f8c:	90                   	nop
80105f8d:	90                   	nop
80105f8e:	90                   	nop
80105f8f:	90                   	nop

80105f90 <idtinit>:

void
idtinit(void)
{
80105f90:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105f91:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105f96:	89 e5                	mov    %esp,%ebp
80105f98:	83 ec 10             	sub    $0x10,%esp
80105f9b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105f9f:	b8 80 6e 11 80       	mov    $0x80116e80,%eax
80105fa4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105fa8:	c1 e8 10             	shr    $0x10,%eax
80105fab:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80105faf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105fb2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105fb5:	c9                   	leave  
80105fb6:	c3                   	ret    
80105fb7:	89 f6                	mov    %esi,%esi
80105fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105fc0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105fc0:	55                   	push   %ebp
80105fc1:	89 e5                	mov    %esp,%ebp
80105fc3:	57                   	push   %edi
80105fc4:	56                   	push   %esi
80105fc5:	53                   	push   %ebx
80105fc6:	83 ec 1c             	sub    $0x1c,%esp
80105fc9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105fcc:	8b 47 30             	mov    0x30(%edi),%eax
80105fcf:	83 f8 40             	cmp    $0x40,%eax
80105fd2:	0f 84 88 01 00 00    	je     80106160 <trap+0x1a0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105fd8:	83 e8 20             	sub    $0x20,%eax
80105fdb:	83 f8 1f             	cmp    $0x1f,%eax
80105fde:	77 10                	ja     80105ff0 <trap+0x30>
80105fe0:	ff 24 85 24 83 10 80 	jmp    *-0x7fef7cdc(,%eax,4)
80105fe7:	89 f6                	mov    %esi,%esi
80105fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105ff0:	e8 fb d7 ff ff       	call   801037f0 <myproc>
80105ff5:	85 c0                	test   %eax,%eax
80105ff7:	0f 84 d7 01 00 00    	je     801061d4 <trap+0x214>
80105ffd:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106001:	0f 84 cd 01 00 00    	je     801061d4 <trap+0x214>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106007:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010600a:	8b 57 38             	mov    0x38(%edi),%edx
8010600d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80106010:	89 55 dc             	mov    %edx,-0x24(%ebp)
80106013:	e8 b8 d7 ff ff       	call   801037d0 <cpuid>
80106018:	8b 77 34             	mov    0x34(%edi),%esi
8010601b:	8b 5f 30             	mov    0x30(%edi),%ebx
8010601e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106021:	e8 ca d7 ff ff       	call   801037f0 <myproc>
80106026:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106029:	e8 c2 d7 ff ff       	call   801037f0 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010602e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106031:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106034:	51                   	push   %ecx
80106035:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106036:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106039:	ff 75 e4             	pushl  -0x1c(%ebp)
8010603c:	56                   	push   %esi
8010603d:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010603e:	83 c2 6c             	add    $0x6c,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106041:	52                   	push   %edx
80106042:	ff 70 10             	pushl  0x10(%eax)
80106045:	68 e0 82 10 80       	push   $0x801082e0
8010604a:	e8 11 a6 ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010604f:	83 c4 20             	add    $0x20,%esp
80106052:	e8 99 d7 ff ff       	call   801037f0 <myproc>
80106057:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010605e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106060:	e8 8b d7 ff ff       	call   801037f0 <myproc>
80106065:	85 c0                	test   %eax,%eax
80106067:	74 0c                	je     80106075 <trap+0xb5>
80106069:	e8 82 d7 ff ff       	call   801037f0 <myproc>
8010606e:	8b 50 24             	mov    0x24(%eax),%edx
80106071:	85 d2                	test   %edx,%edx
80106073:	75 4b                	jne    801060c0 <trap+0x100>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106075:	e8 76 d7 ff ff       	call   801037f0 <myproc>
8010607a:	85 c0                	test   %eax,%eax
8010607c:	74 0b                	je     80106089 <trap+0xc9>
8010607e:	e8 6d d7 ff ff       	call   801037f0 <myproc>
80106083:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106087:	74 4f                	je     801060d8 <trap+0x118>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106089:	e8 62 d7 ff ff       	call   801037f0 <myproc>
8010608e:	85 c0                	test   %eax,%eax
80106090:	74 1d                	je     801060af <trap+0xef>
80106092:	e8 59 d7 ff ff       	call   801037f0 <myproc>
80106097:	8b 40 24             	mov    0x24(%eax),%eax
8010609a:	85 c0                	test   %eax,%eax
8010609c:	74 11                	je     801060af <trap+0xef>
8010609e:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801060a2:	83 e0 03             	and    $0x3,%eax
801060a5:	66 83 f8 03          	cmp    $0x3,%ax
801060a9:	0f 84 da 00 00 00    	je     80106189 <trap+0x1c9>
    exit();
}
801060af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060b2:	5b                   	pop    %ebx
801060b3:	5e                   	pop    %esi
801060b4:	5f                   	pop    %edi
801060b5:	5d                   	pop    %ebp
801060b6:	c3                   	ret    
801060b7:	89 f6                	mov    %esi,%esi
801060b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060c0:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801060c4:	83 e0 03             	and    $0x3,%eax
801060c7:	66 83 f8 03          	cmp    $0x3,%ax
801060cb:	75 a8                	jne    80106075 <trap+0xb5>
    exit();
801060cd:	e8 be e0 ff ff       	call   80104190 <exit>
801060d2:	eb a1                	jmp    80106075 <trap+0xb5>
801060d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801060d8:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801060dc:	75 ab                	jne    80106089 <trap+0xc9>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
801060de:	e8 2d e2 ff ff       	call   80104310 <yield>
801060e3:	eb a4                	jmp    80106089 <trap+0xc9>
801060e5:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801060e8:	e8 e3 d6 ff ff       	call   801037d0 <cpuid>
801060ed:	85 c0                	test   %eax,%eax
801060ef:	0f 84 ab 00 00 00    	je     801061a0 <trap+0x1e0>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
801060f5:	e8 06 c6 ff ff       	call   80102700 <lapiceoi>
    break;
801060fa:	e9 61 ff ff ff       	jmp    80106060 <trap+0xa0>
801060ff:	90                   	nop
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106100:	e8 bb c4 ff ff       	call   801025c0 <kbdintr>
    lapiceoi();
80106105:	e8 f6 c5 ff ff       	call   80102700 <lapiceoi>
    break;
8010610a:	e9 51 ff ff ff       	jmp    80106060 <trap+0xa0>
8010610f:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106110:	e8 5b 02 00 00       	call   80106370 <uartintr>
    lapiceoi();
80106115:	e8 e6 c5 ff ff       	call   80102700 <lapiceoi>
    break;
8010611a:	e9 41 ff ff ff       	jmp    80106060 <trap+0xa0>
8010611f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106120:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106124:	8b 77 38             	mov    0x38(%edi),%esi
80106127:	e8 a4 d6 ff ff       	call   801037d0 <cpuid>
8010612c:	56                   	push   %esi
8010612d:	53                   	push   %ebx
8010612e:	50                   	push   %eax
8010612f:	68 88 82 10 80       	push   $0x80108288
80106134:	e8 27 a5 ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80106139:	e8 c2 c5 ff ff       	call   80102700 <lapiceoi>
    break;
8010613e:	83 c4 10             	add    $0x10,%esp
80106141:	e9 1a ff ff ff       	jmp    80106060 <trap+0xa0>
80106146:	8d 76 00             	lea    0x0(%esi),%esi
80106149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106150:	e8 eb be ff ff       	call   80102040 <ideintr>
80106155:	eb 9e                	jmp    801060f5 <trap+0x135>
80106157:	89 f6                	mov    %esi,%esi
80106159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80106160:	e8 8b d6 ff ff       	call   801037f0 <myproc>
80106165:	8b 58 24             	mov    0x24(%eax),%ebx
80106168:	85 db                	test   %ebx,%ebx
8010616a:	75 2c                	jne    80106198 <trap+0x1d8>
      exit();
    myproc()->tf = tf;
8010616c:	e8 7f d6 ff ff       	call   801037f0 <myproc>
80106171:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106174:	e8 c7 ed ff ff       	call   80104f40 <syscall>
    if(myproc()->killed)
80106179:	e8 72 d6 ff ff       	call   801037f0 <myproc>
8010617e:	8b 48 24             	mov    0x24(%eax),%ecx
80106181:	85 c9                	test   %ecx,%ecx
80106183:	0f 84 26 ff ff ff    	je     801060af <trap+0xef>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106189:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010618c:	5b                   	pop    %ebx
8010618d:	5e                   	pop    %esi
8010618e:	5f                   	pop    %edi
8010618f:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80106190:	e9 fb df ff ff       	jmp    80104190 <exit>
80106195:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80106198:	e8 f3 df ff ff       	call   80104190 <exit>
8010619d:	eb cd                	jmp    8010616c <trap+0x1ac>
8010619f:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
801061a0:	83 ec 0c             	sub    $0xc,%esp
801061a3:	68 40 6e 11 80       	push   $0x80116e40
801061a8:	e8 93 e8 ff ff       	call   80104a40 <acquire>
      ticks++;
      wakeup(&ticks);
801061ad:	c7 04 24 80 76 11 80 	movl   $0x80117680,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
801061b4:	83 05 80 76 11 80 01 	addl   $0x1,0x80117680
      wakeup(&ticks);
801061bb:	e8 d0 e3 ff ff       	call   80104590 <wakeup>
      release(&tickslock);
801061c0:	c7 04 24 40 6e 11 80 	movl   $0x80116e40,(%esp)
801061c7:	e8 24 e9 ff ff       	call   80104af0 <release>
801061cc:	83 c4 10             	add    $0x10,%esp
801061cf:	e9 21 ff ff ff       	jmp    801060f5 <trap+0x135>
801061d4:	0f 20 d6             	mov    %cr2,%esi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801061d7:	8b 5f 38             	mov    0x38(%edi),%ebx
801061da:	e8 f1 d5 ff ff       	call   801037d0 <cpuid>
801061df:	83 ec 0c             	sub    $0xc,%esp
801061e2:	56                   	push   %esi
801061e3:	53                   	push   %ebx
801061e4:	50                   	push   %eax
801061e5:	ff 77 30             	pushl  0x30(%edi)
801061e8:	68 ac 82 10 80       	push   $0x801082ac
801061ed:	e8 6e a4 ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
801061f2:	83 c4 14             	add    $0x14,%esp
801061f5:	68 81 82 10 80       	push   $0x80108281
801061fa:	e8 71 a1 ff ff       	call   80100370 <panic>
801061ff:	90                   	nop

80106200 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106200:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106205:	55                   	push   %ebp
80106206:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106208:	85 c0                	test   %eax,%eax
8010620a:	74 1c                	je     80106228 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010620c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106211:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106212:	a8 01                	test   $0x1,%al
80106214:	74 12                	je     80106228 <uartgetc+0x28>
80106216:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010621b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010621c:	0f b6 c0             	movzbl %al,%eax
}
8010621f:	5d                   	pop    %ebp
80106220:	c3                   	ret    
80106221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80106228:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
8010622d:	5d                   	pop    %ebp
8010622e:	c3                   	ret    
8010622f:	90                   	nop

80106230 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80106230:	55                   	push   %ebp
80106231:	89 e5                	mov    %esp,%ebp
80106233:	57                   	push   %edi
80106234:	56                   	push   %esi
80106235:	53                   	push   %ebx
80106236:	89 c7                	mov    %eax,%edi
80106238:	bb 80 00 00 00       	mov    $0x80,%ebx
8010623d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106242:	83 ec 0c             	sub    $0xc,%esp
80106245:	eb 1b                	jmp    80106262 <uartputc.part.0+0x32>
80106247:	89 f6                	mov    %esi,%esi
80106249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80106250:	83 ec 0c             	sub    $0xc,%esp
80106253:	6a 0a                	push   $0xa
80106255:	e8 c6 c4 ff ff       	call   80102720 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010625a:	83 c4 10             	add    $0x10,%esp
8010625d:	83 eb 01             	sub    $0x1,%ebx
80106260:	74 07                	je     80106269 <uartputc.part.0+0x39>
80106262:	89 f2                	mov    %esi,%edx
80106264:	ec                   	in     (%dx),%al
80106265:	a8 20                	test   $0x20,%al
80106267:	74 e7                	je     80106250 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106269:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010626e:	89 f8                	mov    %edi,%eax
80106270:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80106271:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106274:	5b                   	pop    %ebx
80106275:	5e                   	pop    %esi
80106276:	5f                   	pop    %edi
80106277:	5d                   	pop    %ebp
80106278:	c3                   	ret    
80106279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106280 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106280:	55                   	push   %ebp
80106281:	31 c9                	xor    %ecx,%ecx
80106283:	89 c8                	mov    %ecx,%eax
80106285:	89 e5                	mov    %esp,%ebp
80106287:	57                   	push   %edi
80106288:	56                   	push   %esi
80106289:	53                   	push   %ebx
8010628a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010628f:	89 da                	mov    %ebx,%edx
80106291:	83 ec 0c             	sub    $0xc,%esp
80106294:	ee                   	out    %al,(%dx)
80106295:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010629a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010629f:	89 fa                	mov    %edi,%edx
801062a1:	ee                   	out    %al,(%dx)
801062a2:	b8 0c 00 00 00       	mov    $0xc,%eax
801062a7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062ac:	ee                   	out    %al,(%dx)
801062ad:	be f9 03 00 00       	mov    $0x3f9,%esi
801062b2:	89 c8                	mov    %ecx,%eax
801062b4:	89 f2                	mov    %esi,%edx
801062b6:	ee                   	out    %al,(%dx)
801062b7:	b8 03 00 00 00       	mov    $0x3,%eax
801062bc:	89 fa                	mov    %edi,%edx
801062be:	ee                   	out    %al,(%dx)
801062bf:	ba fc 03 00 00       	mov    $0x3fc,%edx
801062c4:	89 c8                	mov    %ecx,%eax
801062c6:	ee                   	out    %al,(%dx)
801062c7:	b8 01 00 00 00       	mov    $0x1,%eax
801062cc:	89 f2                	mov    %esi,%edx
801062ce:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801062cf:	ba fd 03 00 00       	mov    $0x3fd,%edx
801062d4:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801062d5:	3c ff                	cmp    $0xff,%al
801062d7:	74 5a                	je     80106333 <uartinit+0xb3>
    return;
  uart = 1;
801062d9:	c7 05 c0 b5 10 80 01 	movl   $0x1,0x8010b5c0
801062e0:	00 00 00 
801062e3:	89 da                	mov    %ebx,%edx
801062e5:	ec                   	in     (%dx),%al
801062e6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062eb:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
801062ec:	83 ec 08             	sub    $0x8,%esp
801062ef:	bb a4 83 10 80       	mov    $0x801083a4,%ebx
801062f4:	6a 00                	push   $0x0
801062f6:	6a 04                	push   $0x4
801062f8:	e8 93 bf ff ff       	call   80102290 <ioapicenable>
801062fd:	83 c4 10             	add    $0x10,%esp
80106300:	b8 78 00 00 00       	mov    $0x78,%eax
80106305:	eb 13                	jmp    8010631a <uartinit+0x9a>
80106307:	89 f6                	mov    %esi,%esi
80106309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106310:	83 c3 01             	add    $0x1,%ebx
80106313:	0f be 03             	movsbl (%ebx),%eax
80106316:	84 c0                	test   %al,%al
80106318:	74 19                	je     80106333 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
8010631a:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
80106320:	85 d2                	test   %edx,%edx
80106322:	74 ec                	je     80106310 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106324:	83 c3 01             	add    $0x1,%ebx
80106327:	e8 04 ff ff ff       	call   80106230 <uartputc.part.0>
8010632c:	0f be 03             	movsbl (%ebx),%eax
8010632f:	84 c0                	test   %al,%al
80106331:	75 e7                	jne    8010631a <uartinit+0x9a>
    uartputc(*p);
}
80106333:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106336:	5b                   	pop    %ebx
80106337:	5e                   	pop    %esi
80106338:	5f                   	pop    %edi
80106339:	5d                   	pop    %ebp
8010633a:	c3                   	ret    
8010633b:	90                   	nop
8010633c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106340 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80106340:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80106346:	55                   	push   %ebp
80106347:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80106349:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
8010634b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
8010634e:	74 10                	je     80106360 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106350:	5d                   	pop    %ebp
80106351:	e9 da fe ff ff       	jmp    80106230 <uartputc.part.0>
80106356:	8d 76 00             	lea    0x0(%esi),%esi
80106359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106360:	5d                   	pop    %ebp
80106361:	c3                   	ret    
80106362:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106370 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80106370:	55                   	push   %ebp
80106371:	89 e5                	mov    %esp,%ebp
80106373:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106376:	68 00 62 10 80       	push   $0x80106200
8010637b:	e8 70 a4 ff ff       	call   801007f0 <consoleintr>
}
80106380:	83 c4 10             	add    $0x10,%esp
80106383:	c9                   	leave  
80106384:	c3                   	ret    

80106385 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106385:	6a 00                	push   $0x0
  pushl $0
80106387:	6a 00                	push   $0x0
  jmp alltraps
80106389:	e9 31 fb ff ff       	jmp    80105ebf <alltraps>

8010638e <vector1>:
.globl vector1
vector1:
  pushl $0
8010638e:	6a 00                	push   $0x0
  pushl $1
80106390:	6a 01                	push   $0x1
  jmp alltraps
80106392:	e9 28 fb ff ff       	jmp    80105ebf <alltraps>

80106397 <vector2>:
.globl vector2
vector2:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $2
80106399:	6a 02                	push   $0x2
  jmp alltraps
8010639b:	e9 1f fb ff ff       	jmp    80105ebf <alltraps>

801063a0 <vector3>:
.globl vector3
vector3:
  pushl $0
801063a0:	6a 00                	push   $0x0
  pushl $3
801063a2:	6a 03                	push   $0x3
  jmp alltraps
801063a4:	e9 16 fb ff ff       	jmp    80105ebf <alltraps>

801063a9 <vector4>:
.globl vector4
vector4:
  pushl $0
801063a9:	6a 00                	push   $0x0
  pushl $4
801063ab:	6a 04                	push   $0x4
  jmp alltraps
801063ad:	e9 0d fb ff ff       	jmp    80105ebf <alltraps>

801063b2 <vector5>:
.globl vector5
vector5:
  pushl $0
801063b2:	6a 00                	push   $0x0
  pushl $5
801063b4:	6a 05                	push   $0x5
  jmp alltraps
801063b6:	e9 04 fb ff ff       	jmp    80105ebf <alltraps>

801063bb <vector6>:
.globl vector6
vector6:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $6
801063bd:	6a 06                	push   $0x6
  jmp alltraps
801063bf:	e9 fb fa ff ff       	jmp    80105ebf <alltraps>

801063c4 <vector7>:
.globl vector7
vector7:
  pushl $0
801063c4:	6a 00                	push   $0x0
  pushl $7
801063c6:	6a 07                	push   $0x7
  jmp alltraps
801063c8:	e9 f2 fa ff ff       	jmp    80105ebf <alltraps>

801063cd <vector8>:
.globl vector8
vector8:
  pushl $8
801063cd:	6a 08                	push   $0x8
  jmp alltraps
801063cf:	e9 eb fa ff ff       	jmp    80105ebf <alltraps>

801063d4 <vector9>:
.globl vector9
vector9:
  pushl $0
801063d4:	6a 00                	push   $0x0
  pushl $9
801063d6:	6a 09                	push   $0x9
  jmp alltraps
801063d8:	e9 e2 fa ff ff       	jmp    80105ebf <alltraps>

801063dd <vector10>:
.globl vector10
vector10:
  pushl $10
801063dd:	6a 0a                	push   $0xa
  jmp alltraps
801063df:	e9 db fa ff ff       	jmp    80105ebf <alltraps>

801063e4 <vector11>:
.globl vector11
vector11:
  pushl $11
801063e4:	6a 0b                	push   $0xb
  jmp alltraps
801063e6:	e9 d4 fa ff ff       	jmp    80105ebf <alltraps>

801063eb <vector12>:
.globl vector12
vector12:
  pushl $12
801063eb:	6a 0c                	push   $0xc
  jmp alltraps
801063ed:	e9 cd fa ff ff       	jmp    80105ebf <alltraps>

801063f2 <vector13>:
.globl vector13
vector13:
  pushl $13
801063f2:	6a 0d                	push   $0xd
  jmp alltraps
801063f4:	e9 c6 fa ff ff       	jmp    80105ebf <alltraps>

801063f9 <vector14>:
.globl vector14
vector14:
  pushl $14
801063f9:	6a 0e                	push   $0xe
  jmp alltraps
801063fb:	e9 bf fa ff ff       	jmp    80105ebf <alltraps>

80106400 <vector15>:
.globl vector15
vector15:
  pushl $0
80106400:	6a 00                	push   $0x0
  pushl $15
80106402:	6a 0f                	push   $0xf
  jmp alltraps
80106404:	e9 b6 fa ff ff       	jmp    80105ebf <alltraps>

80106409 <vector16>:
.globl vector16
vector16:
  pushl $0
80106409:	6a 00                	push   $0x0
  pushl $16
8010640b:	6a 10                	push   $0x10
  jmp alltraps
8010640d:	e9 ad fa ff ff       	jmp    80105ebf <alltraps>

80106412 <vector17>:
.globl vector17
vector17:
  pushl $17
80106412:	6a 11                	push   $0x11
  jmp alltraps
80106414:	e9 a6 fa ff ff       	jmp    80105ebf <alltraps>

80106419 <vector18>:
.globl vector18
vector18:
  pushl $0
80106419:	6a 00                	push   $0x0
  pushl $18
8010641b:	6a 12                	push   $0x12
  jmp alltraps
8010641d:	e9 9d fa ff ff       	jmp    80105ebf <alltraps>

80106422 <vector19>:
.globl vector19
vector19:
  pushl $0
80106422:	6a 00                	push   $0x0
  pushl $19
80106424:	6a 13                	push   $0x13
  jmp alltraps
80106426:	e9 94 fa ff ff       	jmp    80105ebf <alltraps>

8010642b <vector20>:
.globl vector20
vector20:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $20
8010642d:	6a 14                	push   $0x14
  jmp alltraps
8010642f:	e9 8b fa ff ff       	jmp    80105ebf <alltraps>

80106434 <vector21>:
.globl vector21
vector21:
  pushl $0
80106434:	6a 00                	push   $0x0
  pushl $21
80106436:	6a 15                	push   $0x15
  jmp alltraps
80106438:	e9 82 fa ff ff       	jmp    80105ebf <alltraps>

8010643d <vector22>:
.globl vector22
vector22:
  pushl $0
8010643d:	6a 00                	push   $0x0
  pushl $22
8010643f:	6a 16                	push   $0x16
  jmp alltraps
80106441:	e9 79 fa ff ff       	jmp    80105ebf <alltraps>

80106446 <vector23>:
.globl vector23
vector23:
  pushl $0
80106446:	6a 00                	push   $0x0
  pushl $23
80106448:	6a 17                	push   $0x17
  jmp alltraps
8010644a:	e9 70 fa ff ff       	jmp    80105ebf <alltraps>

8010644f <vector24>:
.globl vector24
vector24:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $24
80106451:	6a 18                	push   $0x18
  jmp alltraps
80106453:	e9 67 fa ff ff       	jmp    80105ebf <alltraps>

80106458 <vector25>:
.globl vector25
vector25:
  pushl $0
80106458:	6a 00                	push   $0x0
  pushl $25
8010645a:	6a 19                	push   $0x19
  jmp alltraps
8010645c:	e9 5e fa ff ff       	jmp    80105ebf <alltraps>

80106461 <vector26>:
.globl vector26
vector26:
  pushl $0
80106461:	6a 00                	push   $0x0
  pushl $26
80106463:	6a 1a                	push   $0x1a
  jmp alltraps
80106465:	e9 55 fa ff ff       	jmp    80105ebf <alltraps>

8010646a <vector27>:
.globl vector27
vector27:
  pushl $0
8010646a:	6a 00                	push   $0x0
  pushl $27
8010646c:	6a 1b                	push   $0x1b
  jmp alltraps
8010646e:	e9 4c fa ff ff       	jmp    80105ebf <alltraps>

80106473 <vector28>:
.globl vector28
vector28:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $28
80106475:	6a 1c                	push   $0x1c
  jmp alltraps
80106477:	e9 43 fa ff ff       	jmp    80105ebf <alltraps>

8010647c <vector29>:
.globl vector29
vector29:
  pushl $0
8010647c:	6a 00                	push   $0x0
  pushl $29
8010647e:	6a 1d                	push   $0x1d
  jmp alltraps
80106480:	e9 3a fa ff ff       	jmp    80105ebf <alltraps>

80106485 <vector30>:
.globl vector30
vector30:
  pushl $0
80106485:	6a 00                	push   $0x0
  pushl $30
80106487:	6a 1e                	push   $0x1e
  jmp alltraps
80106489:	e9 31 fa ff ff       	jmp    80105ebf <alltraps>

8010648e <vector31>:
.globl vector31
vector31:
  pushl $0
8010648e:	6a 00                	push   $0x0
  pushl $31
80106490:	6a 1f                	push   $0x1f
  jmp alltraps
80106492:	e9 28 fa ff ff       	jmp    80105ebf <alltraps>

80106497 <vector32>:
.globl vector32
vector32:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $32
80106499:	6a 20                	push   $0x20
  jmp alltraps
8010649b:	e9 1f fa ff ff       	jmp    80105ebf <alltraps>

801064a0 <vector33>:
.globl vector33
vector33:
  pushl $0
801064a0:	6a 00                	push   $0x0
  pushl $33
801064a2:	6a 21                	push   $0x21
  jmp alltraps
801064a4:	e9 16 fa ff ff       	jmp    80105ebf <alltraps>

801064a9 <vector34>:
.globl vector34
vector34:
  pushl $0
801064a9:	6a 00                	push   $0x0
  pushl $34
801064ab:	6a 22                	push   $0x22
  jmp alltraps
801064ad:	e9 0d fa ff ff       	jmp    80105ebf <alltraps>

801064b2 <vector35>:
.globl vector35
vector35:
  pushl $0
801064b2:	6a 00                	push   $0x0
  pushl $35
801064b4:	6a 23                	push   $0x23
  jmp alltraps
801064b6:	e9 04 fa ff ff       	jmp    80105ebf <alltraps>

801064bb <vector36>:
.globl vector36
vector36:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $36
801064bd:	6a 24                	push   $0x24
  jmp alltraps
801064bf:	e9 fb f9 ff ff       	jmp    80105ebf <alltraps>

801064c4 <vector37>:
.globl vector37
vector37:
  pushl $0
801064c4:	6a 00                	push   $0x0
  pushl $37
801064c6:	6a 25                	push   $0x25
  jmp alltraps
801064c8:	e9 f2 f9 ff ff       	jmp    80105ebf <alltraps>

801064cd <vector38>:
.globl vector38
vector38:
  pushl $0
801064cd:	6a 00                	push   $0x0
  pushl $38
801064cf:	6a 26                	push   $0x26
  jmp alltraps
801064d1:	e9 e9 f9 ff ff       	jmp    80105ebf <alltraps>

801064d6 <vector39>:
.globl vector39
vector39:
  pushl $0
801064d6:	6a 00                	push   $0x0
  pushl $39
801064d8:	6a 27                	push   $0x27
  jmp alltraps
801064da:	e9 e0 f9 ff ff       	jmp    80105ebf <alltraps>

801064df <vector40>:
.globl vector40
vector40:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $40
801064e1:	6a 28                	push   $0x28
  jmp alltraps
801064e3:	e9 d7 f9 ff ff       	jmp    80105ebf <alltraps>

801064e8 <vector41>:
.globl vector41
vector41:
  pushl $0
801064e8:	6a 00                	push   $0x0
  pushl $41
801064ea:	6a 29                	push   $0x29
  jmp alltraps
801064ec:	e9 ce f9 ff ff       	jmp    80105ebf <alltraps>

801064f1 <vector42>:
.globl vector42
vector42:
  pushl $0
801064f1:	6a 00                	push   $0x0
  pushl $42
801064f3:	6a 2a                	push   $0x2a
  jmp alltraps
801064f5:	e9 c5 f9 ff ff       	jmp    80105ebf <alltraps>

801064fa <vector43>:
.globl vector43
vector43:
  pushl $0
801064fa:	6a 00                	push   $0x0
  pushl $43
801064fc:	6a 2b                	push   $0x2b
  jmp alltraps
801064fe:	e9 bc f9 ff ff       	jmp    80105ebf <alltraps>

80106503 <vector44>:
.globl vector44
vector44:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $44
80106505:	6a 2c                	push   $0x2c
  jmp alltraps
80106507:	e9 b3 f9 ff ff       	jmp    80105ebf <alltraps>

8010650c <vector45>:
.globl vector45
vector45:
  pushl $0
8010650c:	6a 00                	push   $0x0
  pushl $45
8010650e:	6a 2d                	push   $0x2d
  jmp alltraps
80106510:	e9 aa f9 ff ff       	jmp    80105ebf <alltraps>

80106515 <vector46>:
.globl vector46
vector46:
  pushl $0
80106515:	6a 00                	push   $0x0
  pushl $46
80106517:	6a 2e                	push   $0x2e
  jmp alltraps
80106519:	e9 a1 f9 ff ff       	jmp    80105ebf <alltraps>

8010651e <vector47>:
.globl vector47
vector47:
  pushl $0
8010651e:	6a 00                	push   $0x0
  pushl $47
80106520:	6a 2f                	push   $0x2f
  jmp alltraps
80106522:	e9 98 f9 ff ff       	jmp    80105ebf <alltraps>

80106527 <vector48>:
.globl vector48
vector48:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $48
80106529:	6a 30                	push   $0x30
  jmp alltraps
8010652b:	e9 8f f9 ff ff       	jmp    80105ebf <alltraps>

80106530 <vector49>:
.globl vector49
vector49:
  pushl $0
80106530:	6a 00                	push   $0x0
  pushl $49
80106532:	6a 31                	push   $0x31
  jmp alltraps
80106534:	e9 86 f9 ff ff       	jmp    80105ebf <alltraps>

80106539 <vector50>:
.globl vector50
vector50:
  pushl $0
80106539:	6a 00                	push   $0x0
  pushl $50
8010653b:	6a 32                	push   $0x32
  jmp alltraps
8010653d:	e9 7d f9 ff ff       	jmp    80105ebf <alltraps>

80106542 <vector51>:
.globl vector51
vector51:
  pushl $0
80106542:	6a 00                	push   $0x0
  pushl $51
80106544:	6a 33                	push   $0x33
  jmp alltraps
80106546:	e9 74 f9 ff ff       	jmp    80105ebf <alltraps>

8010654b <vector52>:
.globl vector52
vector52:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $52
8010654d:	6a 34                	push   $0x34
  jmp alltraps
8010654f:	e9 6b f9 ff ff       	jmp    80105ebf <alltraps>

80106554 <vector53>:
.globl vector53
vector53:
  pushl $0
80106554:	6a 00                	push   $0x0
  pushl $53
80106556:	6a 35                	push   $0x35
  jmp alltraps
80106558:	e9 62 f9 ff ff       	jmp    80105ebf <alltraps>

8010655d <vector54>:
.globl vector54
vector54:
  pushl $0
8010655d:	6a 00                	push   $0x0
  pushl $54
8010655f:	6a 36                	push   $0x36
  jmp alltraps
80106561:	e9 59 f9 ff ff       	jmp    80105ebf <alltraps>

80106566 <vector55>:
.globl vector55
vector55:
  pushl $0
80106566:	6a 00                	push   $0x0
  pushl $55
80106568:	6a 37                	push   $0x37
  jmp alltraps
8010656a:	e9 50 f9 ff ff       	jmp    80105ebf <alltraps>

8010656f <vector56>:
.globl vector56
vector56:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $56
80106571:	6a 38                	push   $0x38
  jmp alltraps
80106573:	e9 47 f9 ff ff       	jmp    80105ebf <alltraps>

80106578 <vector57>:
.globl vector57
vector57:
  pushl $0
80106578:	6a 00                	push   $0x0
  pushl $57
8010657a:	6a 39                	push   $0x39
  jmp alltraps
8010657c:	e9 3e f9 ff ff       	jmp    80105ebf <alltraps>

80106581 <vector58>:
.globl vector58
vector58:
  pushl $0
80106581:	6a 00                	push   $0x0
  pushl $58
80106583:	6a 3a                	push   $0x3a
  jmp alltraps
80106585:	e9 35 f9 ff ff       	jmp    80105ebf <alltraps>

8010658a <vector59>:
.globl vector59
vector59:
  pushl $0
8010658a:	6a 00                	push   $0x0
  pushl $59
8010658c:	6a 3b                	push   $0x3b
  jmp alltraps
8010658e:	e9 2c f9 ff ff       	jmp    80105ebf <alltraps>

80106593 <vector60>:
.globl vector60
vector60:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $60
80106595:	6a 3c                	push   $0x3c
  jmp alltraps
80106597:	e9 23 f9 ff ff       	jmp    80105ebf <alltraps>

8010659c <vector61>:
.globl vector61
vector61:
  pushl $0
8010659c:	6a 00                	push   $0x0
  pushl $61
8010659e:	6a 3d                	push   $0x3d
  jmp alltraps
801065a0:	e9 1a f9 ff ff       	jmp    80105ebf <alltraps>

801065a5 <vector62>:
.globl vector62
vector62:
  pushl $0
801065a5:	6a 00                	push   $0x0
  pushl $62
801065a7:	6a 3e                	push   $0x3e
  jmp alltraps
801065a9:	e9 11 f9 ff ff       	jmp    80105ebf <alltraps>

801065ae <vector63>:
.globl vector63
vector63:
  pushl $0
801065ae:	6a 00                	push   $0x0
  pushl $63
801065b0:	6a 3f                	push   $0x3f
  jmp alltraps
801065b2:	e9 08 f9 ff ff       	jmp    80105ebf <alltraps>

801065b7 <vector64>:
.globl vector64
vector64:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $64
801065b9:	6a 40                	push   $0x40
  jmp alltraps
801065bb:	e9 ff f8 ff ff       	jmp    80105ebf <alltraps>

801065c0 <vector65>:
.globl vector65
vector65:
  pushl $0
801065c0:	6a 00                	push   $0x0
  pushl $65
801065c2:	6a 41                	push   $0x41
  jmp alltraps
801065c4:	e9 f6 f8 ff ff       	jmp    80105ebf <alltraps>

801065c9 <vector66>:
.globl vector66
vector66:
  pushl $0
801065c9:	6a 00                	push   $0x0
  pushl $66
801065cb:	6a 42                	push   $0x42
  jmp alltraps
801065cd:	e9 ed f8 ff ff       	jmp    80105ebf <alltraps>

801065d2 <vector67>:
.globl vector67
vector67:
  pushl $0
801065d2:	6a 00                	push   $0x0
  pushl $67
801065d4:	6a 43                	push   $0x43
  jmp alltraps
801065d6:	e9 e4 f8 ff ff       	jmp    80105ebf <alltraps>

801065db <vector68>:
.globl vector68
vector68:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $68
801065dd:	6a 44                	push   $0x44
  jmp alltraps
801065df:	e9 db f8 ff ff       	jmp    80105ebf <alltraps>

801065e4 <vector69>:
.globl vector69
vector69:
  pushl $0
801065e4:	6a 00                	push   $0x0
  pushl $69
801065e6:	6a 45                	push   $0x45
  jmp alltraps
801065e8:	e9 d2 f8 ff ff       	jmp    80105ebf <alltraps>

801065ed <vector70>:
.globl vector70
vector70:
  pushl $0
801065ed:	6a 00                	push   $0x0
  pushl $70
801065ef:	6a 46                	push   $0x46
  jmp alltraps
801065f1:	e9 c9 f8 ff ff       	jmp    80105ebf <alltraps>

801065f6 <vector71>:
.globl vector71
vector71:
  pushl $0
801065f6:	6a 00                	push   $0x0
  pushl $71
801065f8:	6a 47                	push   $0x47
  jmp alltraps
801065fa:	e9 c0 f8 ff ff       	jmp    80105ebf <alltraps>

801065ff <vector72>:
.globl vector72
vector72:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $72
80106601:	6a 48                	push   $0x48
  jmp alltraps
80106603:	e9 b7 f8 ff ff       	jmp    80105ebf <alltraps>

80106608 <vector73>:
.globl vector73
vector73:
  pushl $0
80106608:	6a 00                	push   $0x0
  pushl $73
8010660a:	6a 49                	push   $0x49
  jmp alltraps
8010660c:	e9 ae f8 ff ff       	jmp    80105ebf <alltraps>

80106611 <vector74>:
.globl vector74
vector74:
  pushl $0
80106611:	6a 00                	push   $0x0
  pushl $74
80106613:	6a 4a                	push   $0x4a
  jmp alltraps
80106615:	e9 a5 f8 ff ff       	jmp    80105ebf <alltraps>

8010661a <vector75>:
.globl vector75
vector75:
  pushl $0
8010661a:	6a 00                	push   $0x0
  pushl $75
8010661c:	6a 4b                	push   $0x4b
  jmp alltraps
8010661e:	e9 9c f8 ff ff       	jmp    80105ebf <alltraps>

80106623 <vector76>:
.globl vector76
vector76:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $76
80106625:	6a 4c                	push   $0x4c
  jmp alltraps
80106627:	e9 93 f8 ff ff       	jmp    80105ebf <alltraps>

8010662c <vector77>:
.globl vector77
vector77:
  pushl $0
8010662c:	6a 00                	push   $0x0
  pushl $77
8010662e:	6a 4d                	push   $0x4d
  jmp alltraps
80106630:	e9 8a f8 ff ff       	jmp    80105ebf <alltraps>

80106635 <vector78>:
.globl vector78
vector78:
  pushl $0
80106635:	6a 00                	push   $0x0
  pushl $78
80106637:	6a 4e                	push   $0x4e
  jmp alltraps
80106639:	e9 81 f8 ff ff       	jmp    80105ebf <alltraps>

8010663e <vector79>:
.globl vector79
vector79:
  pushl $0
8010663e:	6a 00                	push   $0x0
  pushl $79
80106640:	6a 4f                	push   $0x4f
  jmp alltraps
80106642:	e9 78 f8 ff ff       	jmp    80105ebf <alltraps>

80106647 <vector80>:
.globl vector80
vector80:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $80
80106649:	6a 50                	push   $0x50
  jmp alltraps
8010664b:	e9 6f f8 ff ff       	jmp    80105ebf <alltraps>

80106650 <vector81>:
.globl vector81
vector81:
  pushl $0
80106650:	6a 00                	push   $0x0
  pushl $81
80106652:	6a 51                	push   $0x51
  jmp alltraps
80106654:	e9 66 f8 ff ff       	jmp    80105ebf <alltraps>

80106659 <vector82>:
.globl vector82
vector82:
  pushl $0
80106659:	6a 00                	push   $0x0
  pushl $82
8010665b:	6a 52                	push   $0x52
  jmp alltraps
8010665d:	e9 5d f8 ff ff       	jmp    80105ebf <alltraps>

80106662 <vector83>:
.globl vector83
vector83:
  pushl $0
80106662:	6a 00                	push   $0x0
  pushl $83
80106664:	6a 53                	push   $0x53
  jmp alltraps
80106666:	e9 54 f8 ff ff       	jmp    80105ebf <alltraps>

8010666b <vector84>:
.globl vector84
vector84:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $84
8010666d:	6a 54                	push   $0x54
  jmp alltraps
8010666f:	e9 4b f8 ff ff       	jmp    80105ebf <alltraps>

80106674 <vector85>:
.globl vector85
vector85:
  pushl $0
80106674:	6a 00                	push   $0x0
  pushl $85
80106676:	6a 55                	push   $0x55
  jmp alltraps
80106678:	e9 42 f8 ff ff       	jmp    80105ebf <alltraps>

8010667d <vector86>:
.globl vector86
vector86:
  pushl $0
8010667d:	6a 00                	push   $0x0
  pushl $86
8010667f:	6a 56                	push   $0x56
  jmp alltraps
80106681:	e9 39 f8 ff ff       	jmp    80105ebf <alltraps>

80106686 <vector87>:
.globl vector87
vector87:
  pushl $0
80106686:	6a 00                	push   $0x0
  pushl $87
80106688:	6a 57                	push   $0x57
  jmp alltraps
8010668a:	e9 30 f8 ff ff       	jmp    80105ebf <alltraps>

8010668f <vector88>:
.globl vector88
vector88:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $88
80106691:	6a 58                	push   $0x58
  jmp alltraps
80106693:	e9 27 f8 ff ff       	jmp    80105ebf <alltraps>

80106698 <vector89>:
.globl vector89
vector89:
  pushl $0
80106698:	6a 00                	push   $0x0
  pushl $89
8010669a:	6a 59                	push   $0x59
  jmp alltraps
8010669c:	e9 1e f8 ff ff       	jmp    80105ebf <alltraps>

801066a1 <vector90>:
.globl vector90
vector90:
  pushl $0
801066a1:	6a 00                	push   $0x0
  pushl $90
801066a3:	6a 5a                	push   $0x5a
  jmp alltraps
801066a5:	e9 15 f8 ff ff       	jmp    80105ebf <alltraps>

801066aa <vector91>:
.globl vector91
vector91:
  pushl $0
801066aa:	6a 00                	push   $0x0
  pushl $91
801066ac:	6a 5b                	push   $0x5b
  jmp alltraps
801066ae:	e9 0c f8 ff ff       	jmp    80105ebf <alltraps>

801066b3 <vector92>:
.globl vector92
vector92:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $92
801066b5:	6a 5c                	push   $0x5c
  jmp alltraps
801066b7:	e9 03 f8 ff ff       	jmp    80105ebf <alltraps>

801066bc <vector93>:
.globl vector93
vector93:
  pushl $0
801066bc:	6a 00                	push   $0x0
  pushl $93
801066be:	6a 5d                	push   $0x5d
  jmp alltraps
801066c0:	e9 fa f7 ff ff       	jmp    80105ebf <alltraps>

801066c5 <vector94>:
.globl vector94
vector94:
  pushl $0
801066c5:	6a 00                	push   $0x0
  pushl $94
801066c7:	6a 5e                	push   $0x5e
  jmp alltraps
801066c9:	e9 f1 f7 ff ff       	jmp    80105ebf <alltraps>

801066ce <vector95>:
.globl vector95
vector95:
  pushl $0
801066ce:	6a 00                	push   $0x0
  pushl $95
801066d0:	6a 5f                	push   $0x5f
  jmp alltraps
801066d2:	e9 e8 f7 ff ff       	jmp    80105ebf <alltraps>

801066d7 <vector96>:
.globl vector96
vector96:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $96
801066d9:	6a 60                	push   $0x60
  jmp alltraps
801066db:	e9 df f7 ff ff       	jmp    80105ebf <alltraps>

801066e0 <vector97>:
.globl vector97
vector97:
  pushl $0
801066e0:	6a 00                	push   $0x0
  pushl $97
801066e2:	6a 61                	push   $0x61
  jmp alltraps
801066e4:	e9 d6 f7 ff ff       	jmp    80105ebf <alltraps>

801066e9 <vector98>:
.globl vector98
vector98:
  pushl $0
801066e9:	6a 00                	push   $0x0
  pushl $98
801066eb:	6a 62                	push   $0x62
  jmp alltraps
801066ed:	e9 cd f7 ff ff       	jmp    80105ebf <alltraps>

801066f2 <vector99>:
.globl vector99
vector99:
  pushl $0
801066f2:	6a 00                	push   $0x0
  pushl $99
801066f4:	6a 63                	push   $0x63
  jmp alltraps
801066f6:	e9 c4 f7 ff ff       	jmp    80105ebf <alltraps>

801066fb <vector100>:
.globl vector100
vector100:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $100
801066fd:	6a 64                	push   $0x64
  jmp alltraps
801066ff:	e9 bb f7 ff ff       	jmp    80105ebf <alltraps>

80106704 <vector101>:
.globl vector101
vector101:
  pushl $0
80106704:	6a 00                	push   $0x0
  pushl $101
80106706:	6a 65                	push   $0x65
  jmp alltraps
80106708:	e9 b2 f7 ff ff       	jmp    80105ebf <alltraps>

8010670d <vector102>:
.globl vector102
vector102:
  pushl $0
8010670d:	6a 00                	push   $0x0
  pushl $102
8010670f:	6a 66                	push   $0x66
  jmp alltraps
80106711:	e9 a9 f7 ff ff       	jmp    80105ebf <alltraps>

80106716 <vector103>:
.globl vector103
vector103:
  pushl $0
80106716:	6a 00                	push   $0x0
  pushl $103
80106718:	6a 67                	push   $0x67
  jmp alltraps
8010671a:	e9 a0 f7 ff ff       	jmp    80105ebf <alltraps>

8010671f <vector104>:
.globl vector104
vector104:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $104
80106721:	6a 68                	push   $0x68
  jmp alltraps
80106723:	e9 97 f7 ff ff       	jmp    80105ebf <alltraps>

80106728 <vector105>:
.globl vector105
vector105:
  pushl $0
80106728:	6a 00                	push   $0x0
  pushl $105
8010672a:	6a 69                	push   $0x69
  jmp alltraps
8010672c:	e9 8e f7 ff ff       	jmp    80105ebf <alltraps>

80106731 <vector106>:
.globl vector106
vector106:
  pushl $0
80106731:	6a 00                	push   $0x0
  pushl $106
80106733:	6a 6a                	push   $0x6a
  jmp alltraps
80106735:	e9 85 f7 ff ff       	jmp    80105ebf <alltraps>

8010673a <vector107>:
.globl vector107
vector107:
  pushl $0
8010673a:	6a 00                	push   $0x0
  pushl $107
8010673c:	6a 6b                	push   $0x6b
  jmp alltraps
8010673e:	e9 7c f7 ff ff       	jmp    80105ebf <alltraps>

80106743 <vector108>:
.globl vector108
vector108:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $108
80106745:	6a 6c                	push   $0x6c
  jmp alltraps
80106747:	e9 73 f7 ff ff       	jmp    80105ebf <alltraps>

8010674c <vector109>:
.globl vector109
vector109:
  pushl $0
8010674c:	6a 00                	push   $0x0
  pushl $109
8010674e:	6a 6d                	push   $0x6d
  jmp alltraps
80106750:	e9 6a f7 ff ff       	jmp    80105ebf <alltraps>

80106755 <vector110>:
.globl vector110
vector110:
  pushl $0
80106755:	6a 00                	push   $0x0
  pushl $110
80106757:	6a 6e                	push   $0x6e
  jmp alltraps
80106759:	e9 61 f7 ff ff       	jmp    80105ebf <alltraps>

8010675e <vector111>:
.globl vector111
vector111:
  pushl $0
8010675e:	6a 00                	push   $0x0
  pushl $111
80106760:	6a 6f                	push   $0x6f
  jmp alltraps
80106762:	e9 58 f7 ff ff       	jmp    80105ebf <alltraps>

80106767 <vector112>:
.globl vector112
vector112:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $112
80106769:	6a 70                	push   $0x70
  jmp alltraps
8010676b:	e9 4f f7 ff ff       	jmp    80105ebf <alltraps>

80106770 <vector113>:
.globl vector113
vector113:
  pushl $0
80106770:	6a 00                	push   $0x0
  pushl $113
80106772:	6a 71                	push   $0x71
  jmp alltraps
80106774:	e9 46 f7 ff ff       	jmp    80105ebf <alltraps>

80106779 <vector114>:
.globl vector114
vector114:
  pushl $0
80106779:	6a 00                	push   $0x0
  pushl $114
8010677b:	6a 72                	push   $0x72
  jmp alltraps
8010677d:	e9 3d f7 ff ff       	jmp    80105ebf <alltraps>

80106782 <vector115>:
.globl vector115
vector115:
  pushl $0
80106782:	6a 00                	push   $0x0
  pushl $115
80106784:	6a 73                	push   $0x73
  jmp alltraps
80106786:	e9 34 f7 ff ff       	jmp    80105ebf <alltraps>

8010678b <vector116>:
.globl vector116
vector116:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $116
8010678d:	6a 74                	push   $0x74
  jmp alltraps
8010678f:	e9 2b f7 ff ff       	jmp    80105ebf <alltraps>

80106794 <vector117>:
.globl vector117
vector117:
  pushl $0
80106794:	6a 00                	push   $0x0
  pushl $117
80106796:	6a 75                	push   $0x75
  jmp alltraps
80106798:	e9 22 f7 ff ff       	jmp    80105ebf <alltraps>

8010679d <vector118>:
.globl vector118
vector118:
  pushl $0
8010679d:	6a 00                	push   $0x0
  pushl $118
8010679f:	6a 76                	push   $0x76
  jmp alltraps
801067a1:	e9 19 f7 ff ff       	jmp    80105ebf <alltraps>

801067a6 <vector119>:
.globl vector119
vector119:
  pushl $0
801067a6:	6a 00                	push   $0x0
  pushl $119
801067a8:	6a 77                	push   $0x77
  jmp alltraps
801067aa:	e9 10 f7 ff ff       	jmp    80105ebf <alltraps>

801067af <vector120>:
.globl vector120
vector120:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $120
801067b1:	6a 78                	push   $0x78
  jmp alltraps
801067b3:	e9 07 f7 ff ff       	jmp    80105ebf <alltraps>

801067b8 <vector121>:
.globl vector121
vector121:
  pushl $0
801067b8:	6a 00                	push   $0x0
  pushl $121
801067ba:	6a 79                	push   $0x79
  jmp alltraps
801067bc:	e9 fe f6 ff ff       	jmp    80105ebf <alltraps>

801067c1 <vector122>:
.globl vector122
vector122:
  pushl $0
801067c1:	6a 00                	push   $0x0
  pushl $122
801067c3:	6a 7a                	push   $0x7a
  jmp alltraps
801067c5:	e9 f5 f6 ff ff       	jmp    80105ebf <alltraps>

801067ca <vector123>:
.globl vector123
vector123:
  pushl $0
801067ca:	6a 00                	push   $0x0
  pushl $123
801067cc:	6a 7b                	push   $0x7b
  jmp alltraps
801067ce:	e9 ec f6 ff ff       	jmp    80105ebf <alltraps>

801067d3 <vector124>:
.globl vector124
vector124:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $124
801067d5:	6a 7c                	push   $0x7c
  jmp alltraps
801067d7:	e9 e3 f6 ff ff       	jmp    80105ebf <alltraps>

801067dc <vector125>:
.globl vector125
vector125:
  pushl $0
801067dc:	6a 00                	push   $0x0
  pushl $125
801067de:	6a 7d                	push   $0x7d
  jmp alltraps
801067e0:	e9 da f6 ff ff       	jmp    80105ebf <alltraps>

801067e5 <vector126>:
.globl vector126
vector126:
  pushl $0
801067e5:	6a 00                	push   $0x0
  pushl $126
801067e7:	6a 7e                	push   $0x7e
  jmp alltraps
801067e9:	e9 d1 f6 ff ff       	jmp    80105ebf <alltraps>

801067ee <vector127>:
.globl vector127
vector127:
  pushl $0
801067ee:	6a 00                	push   $0x0
  pushl $127
801067f0:	6a 7f                	push   $0x7f
  jmp alltraps
801067f2:	e9 c8 f6 ff ff       	jmp    80105ebf <alltraps>

801067f7 <vector128>:
.globl vector128
vector128:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $128
801067f9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801067fe:	e9 bc f6 ff ff       	jmp    80105ebf <alltraps>

80106803 <vector129>:
.globl vector129
vector129:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $129
80106805:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010680a:	e9 b0 f6 ff ff       	jmp    80105ebf <alltraps>

8010680f <vector130>:
.globl vector130
vector130:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $130
80106811:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106816:	e9 a4 f6 ff ff       	jmp    80105ebf <alltraps>

8010681b <vector131>:
.globl vector131
vector131:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $131
8010681d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106822:	e9 98 f6 ff ff       	jmp    80105ebf <alltraps>

80106827 <vector132>:
.globl vector132
vector132:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $132
80106829:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010682e:	e9 8c f6 ff ff       	jmp    80105ebf <alltraps>

80106833 <vector133>:
.globl vector133
vector133:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $133
80106835:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010683a:	e9 80 f6 ff ff       	jmp    80105ebf <alltraps>

8010683f <vector134>:
.globl vector134
vector134:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $134
80106841:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106846:	e9 74 f6 ff ff       	jmp    80105ebf <alltraps>

8010684b <vector135>:
.globl vector135
vector135:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $135
8010684d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106852:	e9 68 f6 ff ff       	jmp    80105ebf <alltraps>

80106857 <vector136>:
.globl vector136
vector136:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $136
80106859:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010685e:	e9 5c f6 ff ff       	jmp    80105ebf <alltraps>

80106863 <vector137>:
.globl vector137
vector137:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $137
80106865:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010686a:	e9 50 f6 ff ff       	jmp    80105ebf <alltraps>

8010686f <vector138>:
.globl vector138
vector138:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $138
80106871:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106876:	e9 44 f6 ff ff       	jmp    80105ebf <alltraps>

8010687b <vector139>:
.globl vector139
vector139:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $139
8010687d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106882:	e9 38 f6 ff ff       	jmp    80105ebf <alltraps>

80106887 <vector140>:
.globl vector140
vector140:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $140
80106889:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010688e:	e9 2c f6 ff ff       	jmp    80105ebf <alltraps>

80106893 <vector141>:
.globl vector141
vector141:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $141
80106895:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010689a:	e9 20 f6 ff ff       	jmp    80105ebf <alltraps>

8010689f <vector142>:
.globl vector142
vector142:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $142
801068a1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801068a6:	e9 14 f6 ff ff       	jmp    80105ebf <alltraps>

801068ab <vector143>:
.globl vector143
vector143:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $143
801068ad:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801068b2:	e9 08 f6 ff ff       	jmp    80105ebf <alltraps>

801068b7 <vector144>:
.globl vector144
vector144:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $144
801068b9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801068be:	e9 fc f5 ff ff       	jmp    80105ebf <alltraps>

801068c3 <vector145>:
.globl vector145
vector145:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $145
801068c5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801068ca:	e9 f0 f5 ff ff       	jmp    80105ebf <alltraps>

801068cf <vector146>:
.globl vector146
vector146:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $146
801068d1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801068d6:	e9 e4 f5 ff ff       	jmp    80105ebf <alltraps>

801068db <vector147>:
.globl vector147
vector147:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $147
801068dd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801068e2:	e9 d8 f5 ff ff       	jmp    80105ebf <alltraps>

801068e7 <vector148>:
.globl vector148
vector148:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $148
801068e9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801068ee:	e9 cc f5 ff ff       	jmp    80105ebf <alltraps>

801068f3 <vector149>:
.globl vector149
vector149:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $149
801068f5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801068fa:	e9 c0 f5 ff ff       	jmp    80105ebf <alltraps>

801068ff <vector150>:
.globl vector150
vector150:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $150
80106901:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106906:	e9 b4 f5 ff ff       	jmp    80105ebf <alltraps>

8010690b <vector151>:
.globl vector151
vector151:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $151
8010690d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106912:	e9 a8 f5 ff ff       	jmp    80105ebf <alltraps>

80106917 <vector152>:
.globl vector152
vector152:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $152
80106919:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010691e:	e9 9c f5 ff ff       	jmp    80105ebf <alltraps>

80106923 <vector153>:
.globl vector153
vector153:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $153
80106925:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010692a:	e9 90 f5 ff ff       	jmp    80105ebf <alltraps>

8010692f <vector154>:
.globl vector154
vector154:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $154
80106931:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106936:	e9 84 f5 ff ff       	jmp    80105ebf <alltraps>

8010693b <vector155>:
.globl vector155
vector155:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $155
8010693d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106942:	e9 78 f5 ff ff       	jmp    80105ebf <alltraps>

80106947 <vector156>:
.globl vector156
vector156:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $156
80106949:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010694e:	e9 6c f5 ff ff       	jmp    80105ebf <alltraps>

80106953 <vector157>:
.globl vector157
vector157:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $157
80106955:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010695a:	e9 60 f5 ff ff       	jmp    80105ebf <alltraps>

8010695f <vector158>:
.globl vector158
vector158:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $158
80106961:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106966:	e9 54 f5 ff ff       	jmp    80105ebf <alltraps>

8010696b <vector159>:
.globl vector159
vector159:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $159
8010696d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106972:	e9 48 f5 ff ff       	jmp    80105ebf <alltraps>

80106977 <vector160>:
.globl vector160
vector160:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $160
80106979:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010697e:	e9 3c f5 ff ff       	jmp    80105ebf <alltraps>

80106983 <vector161>:
.globl vector161
vector161:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $161
80106985:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010698a:	e9 30 f5 ff ff       	jmp    80105ebf <alltraps>

8010698f <vector162>:
.globl vector162
vector162:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $162
80106991:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106996:	e9 24 f5 ff ff       	jmp    80105ebf <alltraps>

8010699b <vector163>:
.globl vector163
vector163:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $163
8010699d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801069a2:	e9 18 f5 ff ff       	jmp    80105ebf <alltraps>

801069a7 <vector164>:
.globl vector164
vector164:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $164
801069a9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801069ae:	e9 0c f5 ff ff       	jmp    80105ebf <alltraps>

801069b3 <vector165>:
.globl vector165
vector165:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $165
801069b5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801069ba:	e9 00 f5 ff ff       	jmp    80105ebf <alltraps>

801069bf <vector166>:
.globl vector166
vector166:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $166
801069c1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801069c6:	e9 f4 f4 ff ff       	jmp    80105ebf <alltraps>

801069cb <vector167>:
.globl vector167
vector167:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $167
801069cd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801069d2:	e9 e8 f4 ff ff       	jmp    80105ebf <alltraps>

801069d7 <vector168>:
.globl vector168
vector168:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $168
801069d9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801069de:	e9 dc f4 ff ff       	jmp    80105ebf <alltraps>

801069e3 <vector169>:
.globl vector169
vector169:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $169
801069e5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801069ea:	e9 d0 f4 ff ff       	jmp    80105ebf <alltraps>

801069ef <vector170>:
.globl vector170
vector170:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $170
801069f1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801069f6:	e9 c4 f4 ff ff       	jmp    80105ebf <alltraps>

801069fb <vector171>:
.globl vector171
vector171:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $171
801069fd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106a02:	e9 b8 f4 ff ff       	jmp    80105ebf <alltraps>

80106a07 <vector172>:
.globl vector172
vector172:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $172
80106a09:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106a0e:	e9 ac f4 ff ff       	jmp    80105ebf <alltraps>

80106a13 <vector173>:
.globl vector173
vector173:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $173
80106a15:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106a1a:	e9 a0 f4 ff ff       	jmp    80105ebf <alltraps>

80106a1f <vector174>:
.globl vector174
vector174:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $174
80106a21:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106a26:	e9 94 f4 ff ff       	jmp    80105ebf <alltraps>

80106a2b <vector175>:
.globl vector175
vector175:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $175
80106a2d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106a32:	e9 88 f4 ff ff       	jmp    80105ebf <alltraps>

80106a37 <vector176>:
.globl vector176
vector176:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $176
80106a39:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106a3e:	e9 7c f4 ff ff       	jmp    80105ebf <alltraps>

80106a43 <vector177>:
.globl vector177
vector177:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $177
80106a45:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106a4a:	e9 70 f4 ff ff       	jmp    80105ebf <alltraps>

80106a4f <vector178>:
.globl vector178
vector178:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $178
80106a51:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106a56:	e9 64 f4 ff ff       	jmp    80105ebf <alltraps>

80106a5b <vector179>:
.globl vector179
vector179:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $179
80106a5d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106a62:	e9 58 f4 ff ff       	jmp    80105ebf <alltraps>

80106a67 <vector180>:
.globl vector180
vector180:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $180
80106a69:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106a6e:	e9 4c f4 ff ff       	jmp    80105ebf <alltraps>

80106a73 <vector181>:
.globl vector181
vector181:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $181
80106a75:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106a7a:	e9 40 f4 ff ff       	jmp    80105ebf <alltraps>

80106a7f <vector182>:
.globl vector182
vector182:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $182
80106a81:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106a86:	e9 34 f4 ff ff       	jmp    80105ebf <alltraps>

80106a8b <vector183>:
.globl vector183
vector183:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $183
80106a8d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106a92:	e9 28 f4 ff ff       	jmp    80105ebf <alltraps>

80106a97 <vector184>:
.globl vector184
vector184:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $184
80106a99:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106a9e:	e9 1c f4 ff ff       	jmp    80105ebf <alltraps>

80106aa3 <vector185>:
.globl vector185
vector185:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $185
80106aa5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106aaa:	e9 10 f4 ff ff       	jmp    80105ebf <alltraps>

80106aaf <vector186>:
.globl vector186
vector186:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $186
80106ab1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106ab6:	e9 04 f4 ff ff       	jmp    80105ebf <alltraps>

80106abb <vector187>:
.globl vector187
vector187:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $187
80106abd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106ac2:	e9 f8 f3 ff ff       	jmp    80105ebf <alltraps>

80106ac7 <vector188>:
.globl vector188
vector188:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $188
80106ac9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106ace:	e9 ec f3 ff ff       	jmp    80105ebf <alltraps>

80106ad3 <vector189>:
.globl vector189
vector189:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $189
80106ad5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106ada:	e9 e0 f3 ff ff       	jmp    80105ebf <alltraps>

80106adf <vector190>:
.globl vector190
vector190:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $190
80106ae1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106ae6:	e9 d4 f3 ff ff       	jmp    80105ebf <alltraps>

80106aeb <vector191>:
.globl vector191
vector191:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $191
80106aed:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106af2:	e9 c8 f3 ff ff       	jmp    80105ebf <alltraps>

80106af7 <vector192>:
.globl vector192
vector192:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $192
80106af9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106afe:	e9 bc f3 ff ff       	jmp    80105ebf <alltraps>

80106b03 <vector193>:
.globl vector193
vector193:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $193
80106b05:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106b0a:	e9 b0 f3 ff ff       	jmp    80105ebf <alltraps>

80106b0f <vector194>:
.globl vector194
vector194:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $194
80106b11:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106b16:	e9 a4 f3 ff ff       	jmp    80105ebf <alltraps>

80106b1b <vector195>:
.globl vector195
vector195:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $195
80106b1d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106b22:	e9 98 f3 ff ff       	jmp    80105ebf <alltraps>

80106b27 <vector196>:
.globl vector196
vector196:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $196
80106b29:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106b2e:	e9 8c f3 ff ff       	jmp    80105ebf <alltraps>

80106b33 <vector197>:
.globl vector197
vector197:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $197
80106b35:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106b3a:	e9 80 f3 ff ff       	jmp    80105ebf <alltraps>

80106b3f <vector198>:
.globl vector198
vector198:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $198
80106b41:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106b46:	e9 74 f3 ff ff       	jmp    80105ebf <alltraps>

80106b4b <vector199>:
.globl vector199
vector199:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $199
80106b4d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106b52:	e9 68 f3 ff ff       	jmp    80105ebf <alltraps>

80106b57 <vector200>:
.globl vector200
vector200:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $200
80106b59:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106b5e:	e9 5c f3 ff ff       	jmp    80105ebf <alltraps>

80106b63 <vector201>:
.globl vector201
vector201:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $201
80106b65:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106b6a:	e9 50 f3 ff ff       	jmp    80105ebf <alltraps>

80106b6f <vector202>:
.globl vector202
vector202:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $202
80106b71:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106b76:	e9 44 f3 ff ff       	jmp    80105ebf <alltraps>

80106b7b <vector203>:
.globl vector203
vector203:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $203
80106b7d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106b82:	e9 38 f3 ff ff       	jmp    80105ebf <alltraps>

80106b87 <vector204>:
.globl vector204
vector204:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $204
80106b89:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106b8e:	e9 2c f3 ff ff       	jmp    80105ebf <alltraps>

80106b93 <vector205>:
.globl vector205
vector205:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $205
80106b95:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106b9a:	e9 20 f3 ff ff       	jmp    80105ebf <alltraps>

80106b9f <vector206>:
.globl vector206
vector206:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $206
80106ba1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106ba6:	e9 14 f3 ff ff       	jmp    80105ebf <alltraps>

80106bab <vector207>:
.globl vector207
vector207:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $207
80106bad:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106bb2:	e9 08 f3 ff ff       	jmp    80105ebf <alltraps>

80106bb7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $208
80106bb9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106bbe:	e9 fc f2 ff ff       	jmp    80105ebf <alltraps>

80106bc3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $209
80106bc5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106bca:	e9 f0 f2 ff ff       	jmp    80105ebf <alltraps>

80106bcf <vector210>:
.globl vector210
vector210:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $210
80106bd1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106bd6:	e9 e4 f2 ff ff       	jmp    80105ebf <alltraps>

80106bdb <vector211>:
.globl vector211
vector211:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $211
80106bdd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106be2:	e9 d8 f2 ff ff       	jmp    80105ebf <alltraps>

80106be7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $212
80106be9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106bee:	e9 cc f2 ff ff       	jmp    80105ebf <alltraps>

80106bf3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $213
80106bf5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106bfa:	e9 c0 f2 ff ff       	jmp    80105ebf <alltraps>

80106bff <vector214>:
.globl vector214
vector214:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $214
80106c01:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106c06:	e9 b4 f2 ff ff       	jmp    80105ebf <alltraps>

80106c0b <vector215>:
.globl vector215
vector215:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $215
80106c0d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106c12:	e9 a8 f2 ff ff       	jmp    80105ebf <alltraps>

80106c17 <vector216>:
.globl vector216
vector216:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $216
80106c19:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106c1e:	e9 9c f2 ff ff       	jmp    80105ebf <alltraps>

80106c23 <vector217>:
.globl vector217
vector217:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $217
80106c25:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106c2a:	e9 90 f2 ff ff       	jmp    80105ebf <alltraps>

80106c2f <vector218>:
.globl vector218
vector218:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $218
80106c31:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106c36:	e9 84 f2 ff ff       	jmp    80105ebf <alltraps>

80106c3b <vector219>:
.globl vector219
vector219:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $219
80106c3d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106c42:	e9 78 f2 ff ff       	jmp    80105ebf <alltraps>

80106c47 <vector220>:
.globl vector220
vector220:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $220
80106c49:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106c4e:	e9 6c f2 ff ff       	jmp    80105ebf <alltraps>

80106c53 <vector221>:
.globl vector221
vector221:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $221
80106c55:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106c5a:	e9 60 f2 ff ff       	jmp    80105ebf <alltraps>

80106c5f <vector222>:
.globl vector222
vector222:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $222
80106c61:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106c66:	e9 54 f2 ff ff       	jmp    80105ebf <alltraps>

80106c6b <vector223>:
.globl vector223
vector223:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $223
80106c6d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106c72:	e9 48 f2 ff ff       	jmp    80105ebf <alltraps>

80106c77 <vector224>:
.globl vector224
vector224:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $224
80106c79:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106c7e:	e9 3c f2 ff ff       	jmp    80105ebf <alltraps>

80106c83 <vector225>:
.globl vector225
vector225:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $225
80106c85:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106c8a:	e9 30 f2 ff ff       	jmp    80105ebf <alltraps>

80106c8f <vector226>:
.globl vector226
vector226:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $226
80106c91:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106c96:	e9 24 f2 ff ff       	jmp    80105ebf <alltraps>

80106c9b <vector227>:
.globl vector227
vector227:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $227
80106c9d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106ca2:	e9 18 f2 ff ff       	jmp    80105ebf <alltraps>

80106ca7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $228
80106ca9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106cae:	e9 0c f2 ff ff       	jmp    80105ebf <alltraps>

80106cb3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $229
80106cb5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106cba:	e9 00 f2 ff ff       	jmp    80105ebf <alltraps>

80106cbf <vector230>:
.globl vector230
vector230:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $230
80106cc1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106cc6:	e9 f4 f1 ff ff       	jmp    80105ebf <alltraps>

80106ccb <vector231>:
.globl vector231
vector231:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $231
80106ccd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106cd2:	e9 e8 f1 ff ff       	jmp    80105ebf <alltraps>

80106cd7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $232
80106cd9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106cde:	e9 dc f1 ff ff       	jmp    80105ebf <alltraps>

80106ce3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $233
80106ce5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106cea:	e9 d0 f1 ff ff       	jmp    80105ebf <alltraps>

80106cef <vector234>:
.globl vector234
vector234:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $234
80106cf1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106cf6:	e9 c4 f1 ff ff       	jmp    80105ebf <alltraps>

80106cfb <vector235>:
.globl vector235
vector235:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $235
80106cfd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106d02:	e9 b8 f1 ff ff       	jmp    80105ebf <alltraps>

80106d07 <vector236>:
.globl vector236
vector236:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $236
80106d09:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106d0e:	e9 ac f1 ff ff       	jmp    80105ebf <alltraps>

80106d13 <vector237>:
.globl vector237
vector237:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $237
80106d15:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106d1a:	e9 a0 f1 ff ff       	jmp    80105ebf <alltraps>

80106d1f <vector238>:
.globl vector238
vector238:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $238
80106d21:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106d26:	e9 94 f1 ff ff       	jmp    80105ebf <alltraps>

80106d2b <vector239>:
.globl vector239
vector239:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $239
80106d2d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106d32:	e9 88 f1 ff ff       	jmp    80105ebf <alltraps>

80106d37 <vector240>:
.globl vector240
vector240:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $240
80106d39:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106d3e:	e9 7c f1 ff ff       	jmp    80105ebf <alltraps>

80106d43 <vector241>:
.globl vector241
vector241:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $241
80106d45:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106d4a:	e9 70 f1 ff ff       	jmp    80105ebf <alltraps>

80106d4f <vector242>:
.globl vector242
vector242:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $242
80106d51:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106d56:	e9 64 f1 ff ff       	jmp    80105ebf <alltraps>

80106d5b <vector243>:
.globl vector243
vector243:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $243
80106d5d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106d62:	e9 58 f1 ff ff       	jmp    80105ebf <alltraps>

80106d67 <vector244>:
.globl vector244
vector244:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $244
80106d69:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106d6e:	e9 4c f1 ff ff       	jmp    80105ebf <alltraps>

80106d73 <vector245>:
.globl vector245
vector245:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $245
80106d75:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106d7a:	e9 40 f1 ff ff       	jmp    80105ebf <alltraps>

80106d7f <vector246>:
.globl vector246
vector246:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $246
80106d81:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106d86:	e9 34 f1 ff ff       	jmp    80105ebf <alltraps>

80106d8b <vector247>:
.globl vector247
vector247:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $247
80106d8d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106d92:	e9 28 f1 ff ff       	jmp    80105ebf <alltraps>

80106d97 <vector248>:
.globl vector248
vector248:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $248
80106d99:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106d9e:	e9 1c f1 ff ff       	jmp    80105ebf <alltraps>

80106da3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $249
80106da5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106daa:	e9 10 f1 ff ff       	jmp    80105ebf <alltraps>

80106daf <vector250>:
.globl vector250
vector250:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $250
80106db1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106db6:	e9 04 f1 ff ff       	jmp    80105ebf <alltraps>

80106dbb <vector251>:
.globl vector251
vector251:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $251
80106dbd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106dc2:	e9 f8 f0 ff ff       	jmp    80105ebf <alltraps>

80106dc7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $252
80106dc9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106dce:	e9 ec f0 ff ff       	jmp    80105ebf <alltraps>

80106dd3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $253
80106dd5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106dda:	e9 e0 f0 ff ff       	jmp    80105ebf <alltraps>

80106ddf <vector254>:
.globl vector254
vector254:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $254
80106de1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106de6:	e9 d4 f0 ff ff       	jmp    80105ebf <alltraps>

80106deb <vector255>:
.globl vector255
vector255:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $255
80106ded:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106df2:	e9 c8 f0 ff ff       	jmp    80105ebf <alltraps>
80106df7:	66 90                	xchg   %ax,%ax
80106df9:	66 90                	xchg   %ax,%ax
80106dfb:	66 90                	xchg   %ax,%ax
80106dfd:	66 90                	xchg   %ax,%ax
80106dff:	90                   	nop

80106e00 <sgenrand>:
static int mti=N+1; /* mti==N+1 means mt[N] is not initialized */

/* initializing the array with a NONZERO seed */
void
sgenrand(unsigned long seed)
{
80106e00:	55                   	push   %ebp
80106e01:	b8 e4 b5 10 80       	mov    $0x8010b5e4,%eax
80106e06:	89 e5                	mov    %esp,%ebp
80106e08:	8b 55 08             	mov    0x8(%ebp),%edx
    /* setting initial seeds to mt[N] using         */
    /* the generator Line 25 of Table 1 in          */
    /* [KNUTH 1981, The Art of Computer Programming */
    /*    Vol. 2 (2nd Ed.), pp102]                  */
    mt[0]= seed & 0xffffffff;
80106e0b:	89 15 e0 b5 10 80    	mov    %edx,0x8010b5e0
80106e11:	eb 08                	jmp    80106e1b <sgenrand+0x1b>
80106e13:	90                   	nop
80106e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e18:	83 c0 04             	add    $0x4,%eax
    for (mti=1; mti<N; mti++)
        mt[mti] = (69069 * mt[mti-1]) & 0xffffffff;
80106e1b:	69 d2 cd 0d 01 00    	imul   $0x10dcd,%edx,%edx
    /* setting initial seeds to mt[N] using         */
    /* the generator Line 25 of Table 1 in          */
    /* [KNUTH 1981, The Art of Computer Programming */
    /*    Vol. 2 (2nd Ed.), pp102]                  */
    mt[0]= seed & 0xffffffff;
    for (mti=1; mti<N; mti++)
80106e21:	3d 9c bf 10 80       	cmp    $0x8010bf9c,%eax
        mt[mti] = (69069 * mt[mti-1]) & 0xffffffff;
80106e26:	89 10                	mov    %edx,(%eax)
    /* setting initial seeds to mt[N] using         */
    /* the generator Line 25 of Table 1 in          */
    /* [KNUTH 1981, The Art of Computer Programming */
    /*    Vol. 2 (2nd Ed.), pp102]                  */
    mt[0]= seed & 0xffffffff;
    for (mti=1; mti<N; mti++)
80106e28:	75 ee                	jne    80106e18 <sgenrand+0x18>
80106e2a:	c7 05 18 b4 10 80 70 	movl   $0x270,0x8010b418
80106e31:	02 00 00 
        mt[mti] = (69069 * mt[mti-1]) & 0xffffffff;
}
80106e34:	5d                   	pop    %ebp
80106e35:	c3                   	ret    
80106e36:	8d 76 00             	lea    0x0(%esi),%esi
80106e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e40 <genrand>:
{
    unsigned long y;
    static unsigned long mag01[2]={0x0, MATRIX_A};
    /* mag01[x] = x * MATRIX_A  for x=0,1 */

    if (mti >= N) { /* generate N words at one time */
80106e40:	a1 18 b4 10 80       	mov    0x8010b418,%eax
        mt[mti] = (69069 * mt[mti-1]) & 0xffffffff;
}

long /* for integer generation */
genrand()
{
80106e45:	55                   	push   %ebp
80106e46:	89 e5                	mov    %esp,%ebp
80106e48:	53                   	push   %ebx
    unsigned long y;
    static unsigned long mag01[2]={0x0, MATRIX_A};
    /* mag01[x] = x * MATRIX_A  for x=0,1 */

    if (mti >= N) { /* generate N words at one time */
80106e49:	3d 6f 02 00 00       	cmp    $0x26f,%eax
80106e4e:	0f 8e f2 00 00 00    	jle    80106f46 <genrand+0x106>
        int kk;

        if (mti == N+1)   /* if sgenrand() has not been called, */
80106e54:	3d 71 02 00 00       	cmp    $0x271,%eax
80106e59:	0f 84 f3 00 00 00    	je     80106f52 <genrand+0x112>
80106e5f:	b9 e0 b5 10 80       	mov    $0x8010b5e0,%ecx
80106e64:	ba 6c b9 10 80       	mov    $0x8010b96c,%edx
80106e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            sgenrand(4357); /* a default initial seed is used   */

        for (kk=0;kk<N-M;kk++) {
            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
80106e70:	8b 19                	mov    (%ecx),%ebx
80106e72:	8b 41 04             	mov    0x4(%ecx),%eax
80106e75:	83 c1 04             	add    $0x4,%ecx
80106e78:	81 e3 00 00 00 80    	and    $0x80000000,%ebx
80106e7e:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
80106e83:	09 d8                	or     %ebx,%eax
            mt[kk] = mt[kk+M] ^ (y >> 1) ^ mag01[y & 0x1];
80106e85:	89 c3                	mov    %eax,%ebx
80106e87:	83 e0 01             	and    $0x1,%eax
80106e8a:	d1 eb                	shr    %ebx
80106e8c:	33 99 30 06 00 00    	xor    0x630(%ecx),%ebx
80106e92:	33 1c 85 ac 83 10 80 	xor    -0x7fef7c54(,%eax,4),%ebx
80106e99:	89 59 fc             	mov    %ebx,-0x4(%ecx)
        int kk;

        if (mti == N+1)   /* if sgenrand() has not been called, */
            sgenrand(4357); /* a default initial seed is used   */

        for (kk=0;kk<N-M;kk++) {
80106e9c:	39 ca                	cmp    %ecx,%edx
80106e9e:	75 d0                	jne    80106e70 <genrand+0x30>
80106ea0:	b9 9c bf 10 80       	mov    $0x8010bf9c,%ecx
80106ea5:	8d 76 00             	lea    0x0(%esi),%esi
            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
            mt[kk] = mt[kk+M] ^ (y >> 1) ^ mag01[y & 0x1];
        }
        for (;kk<N-1;kk++) {
            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
80106ea8:	8b 1a                	mov    (%edx),%ebx
80106eaa:	8b 42 04             	mov    0x4(%edx),%eax
80106ead:	83 c2 04             	add    $0x4,%edx
80106eb0:	81 e3 00 00 00 80    	and    $0x80000000,%ebx
80106eb6:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
80106ebb:	09 d8                	or     %ebx,%eax
            mt[kk] = mt[kk+(M-N)] ^ (y >> 1) ^ mag01[y & 0x1];
80106ebd:	89 c3                	mov    %eax,%ebx
80106ebf:	83 e0 01             	and    $0x1,%eax
80106ec2:	d1 eb                	shr    %ebx
80106ec4:	33 9a 70 fc ff ff    	xor    -0x390(%edx),%ebx
80106eca:	33 1c 85 ac 83 10 80 	xor    -0x7fef7c54(,%eax,4),%ebx
80106ed1:	89 5a fc             	mov    %ebx,-0x4(%edx)

        for (kk=0;kk<N-M;kk++) {
            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
            mt[kk] = mt[kk+M] ^ (y >> 1) ^ mag01[y & 0x1];
        }
        for (;kk<N-1;kk++) {
80106ed4:	39 d1                	cmp    %edx,%ecx
80106ed6:	75 d0                	jne    80106ea8 <genrand+0x68>
            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
            mt[kk] = mt[kk+(M-N)] ^ (y >> 1) ^ mag01[y & 0x1];
        }
        y = (mt[N-1]&UPPER_MASK)|(mt[0]&LOWER_MASK);
80106ed8:	a1 e0 b5 10 80       	mov    0x8010b5e0,%eax
80106edd:	8b 0d 9c bf 10 80    	mov    0x8010bf9c,%ecx
80106ee3:	89 c2                	mov    %eax,%edx
80106ee5:	81 e1 00 00 00 80    	and    $0x80000000,%ecx
80106eeb:	81 e2 ff ff ff 7f    	and    $0x7fffffff,%edx
80106ef1:	09 ca                	or     %ecx,%edx
        mt[N-1] = mt[M-1] ^ (y >> 1) ^ mag01[y & 0x1];
80106ef3:	89 d1                	mov    %edx,%ecx
80106ef5:	83 e2 01             	and    $0x1,%edx
80106ef8:	d1 e9                	shr    %ecx
80106efa:	33 0d 10 bc 10 80    	xor    0x8010bc10,%ecx
80106f00:	33 0c 95 ac 83 10 80 	xor    -0x7fef7c54(,%edx,4),%ecx
80106f07:	ba 01 00 00 00       	mov    $0x1,%edx
80106f0c:	89 0d 9c bf 10 80    	mov    %ecx,0x8010bf9c

        mti = 0;
    }
  
    y = mt[mti++];
80106f12:	89 15 18 b4 10 80    	mov    %edx,0x8010b418
    y ^= TEMPERING_SHIFT_U(y);
80106f18:	89 c2                	mov    %eax,%edx
80106f1a:	c1 ea 0b             	shr    $0xb,%edx
80106f1d:	31 c2                	xor    %eax,%edx
    y ^= TEMPERING_SHIFT_S(y) & TEMPERING_MASK_B;
80106f1f:	89 d0                	mov    %edx,%eax
80106f21:	c1 e0 07             	shl    $0x7,%eax
80106f24:	25 80 56 2c 9d       	and    $0x9d2c5680,%eax
80106f29:	31 c2                	xor    %eax,%edx
    y ^= TEMPERING_SHIFT_T(y) & TEMPERING_MASK_C;
80106f2b:	89 d0                	mov    %edx,%eax
80106f2d:	c1 e0 0f             	shl    $0xf,%eax
80106f30:	25 00 00 c6 ef       	and    $0xefc60000,%eax
80106f35:	31 d0                	xor    %edx,%eax
    y ^= TEMPERING_SHIFT_L(y);
80106f37:	89 c2                	mov    %eax,%edx
80106f39:	c1 ea 12             	shr    $0x12,%edx

    // Strip off uppermost bit because we want a long,
    // not an unsigned long
    return y & RAND_MAX;
80106f3c:	31 d0                	xor    %edx,%eax
80106f3e:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
80106f43:	5b                   	pop    %ebx
80106f44:	5d                   	pop    %ebp
80106f45:	c3                   	ret    
80106f46:	8d 50 01             	lea    0x1(%eax),%edx
80106f49:	8b 04 85 e0 b5 10 80 	mov    -0x7fef4a20(,%eax,4),%eax
80106f50:	eb c0                	jmp    80106f12 <genrand+0xd2>
{
    /* setting initial seeds to mt[N] using         */
    /* the generator Line 25 of Table 1 in          */
    /* [KNUTH 1981, The Art of Computer Programming */
    /*    Vol. 2 (2nd Ed.), pp102]                  */
    mt[0]= seed & 0xffffffff;
80106f52:	c7 05 e0 b5 10 80 05 	movl   $0x1105,0x8010b5e0
80106f59:	11 00 00 
80106f5c:	b8 e4 b5 10 80       	mov    $0x8010b5e4,%eax
80106f61:	b9 9c bf 10 80       	mov    $0x8010bf9c,%ecx
80106f66:	ba 05 11 00 00       	mov    $0x1105,%edx
80106f6b:	eb 06                	jmp    80106f73 <genrand+0x133>
80106f6d:	8d 76 00             	lea    0x0(%esi),%esi
80106f70:	83 c0 04             	add    $0x4,%eax
    for (mti=1; mti<N; mti++)
        mt[mti] = (69069 * mt[mti-1]) & 0xffffffff;
80106f73:	69 d2 cd 0d 01 00    	imul   $0x10dcd,%edx,%edx
    /* setting initial seeds to mt[N] using         */
    /* the generator Line 25 of Table 1 in          */
    /* [KNUTH 1981, The Art of Computer Programming */
    /*    Vol. 2 (2nd Ed.), pp102]                  */
    mt[0]= seed & 0xffffffff;
    for (mti=1; mti<N; mti++)
80106f79:	39 c1                	cmp    %eax,%ecx
        mt[mti] = (69069 * mt[mti-1]) & 0xffffffff;
80106f7b:	89 10                	mov    %edx,(%eax)
    /* setting initial seeds to mt[N] using         */
    /* the generator Line 25 of Table 1 in          */
    /* [KNUTH 1981, The Art of Computer Programming */
    /*    Vol. 2 (2nd Ed.), pp102]                  */
    mt[0]= seed & 0xffffffff;
    for (mti=1; mti<N; mti++)
80106f7d:	75 f1                	jne    80106f70 <genrand+0x130>
80106f7f:	e9 db fe ff ff       	jmp    80106e5f <genrand+0x1f>
80106f84:	66 90                	xchg   %ax,%ax
80106f86:	66 90                	xchg   %ax,%ax
80106f88:	66 90                	xchg   %ax,%ax
80106f8a:	66 90                	xchg   %ax,%ax
80106f8c:	66 90                	xchg   %ax,%ax
80106f8e:	66 90                	xchg   %ax,%ax

80106f90 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106f90:	55                   	push   %ebp
80106f91:	89 e5                	mov    %esp,%ebp
80106f93:	57                   	push   %edi
80106f94:	56                   	push   %esi
80106f95:	53                   	push   %ebx
80106f96:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106f98:	c1 ea 16             	shr    $0x16,%edx
80106f9b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106f9e:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106fa1:	8b 07                	mov    (%edi),%eax
80106fa3:	a8 01                	test   $0x1,%al
80106fa5:	74 29                	je     80106fd0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106fa7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106fac:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106fb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106fb5:	c1 eb 0a             	shr    $0xa,%ebx
80106fb8:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
80106fbe:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106fc1:	5b                   	pop    %ebx
80106fc2:	5e                   	pop    %esi
80106fc3:	5f                   	pop    %edi
80106fc4:	5d                   	pop    %ebp
80106fc5:	c3                   	ret    
80106fc6:	8d 76 00             	lea    0x0(%esi),%esi
80106fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106fd0:	85 c9                	test   %ecx,%ecx
80106fd2:	74 2c                	je     80107000 <walkpgdir+0x70>
80106fd4:	e8 a7 b4 ff ff       	call   80102480 <kalloc>
80106fd9:	85 c0                	test   %eax,%eax
80106fdb:	89 c6                	mov    %eax,%esi
80106fdd:	74 21                	je     80107000 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80106fdf:	83 ec 04             	sub    $0x4,%esp
80106fe2:	68 00 10 00 00       	push   $0x1000
80106fe7:	6a 00                	push   $0x0
80106fe9:	50                   	push   %eax
80106fea:	e8 51 db ff ff       	call   80104b40 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106fef:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106ff5:	83 c4 10             	add    $0x10,%esp
80106ff8:	83 c8 07             	or     $0x7,%eax
80106ffb:	89 07                	mov    %eax,(%edi)
80106ffd:	eb b3                	jmp    80106fb2 <walkpgdir+0x22>
80106fff:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
80107000:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80107003:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80107005:	5b                   	pop    %ebx
80107006:	5e                   	pop    %esi
80107007:	5f                   	pop    %edi
80107008:	5d                   	pop    %ebp
80107009:	c3                   	ret    
8010700a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107010 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	57                   	push   %edi
80107014:	56                   	push   %esi
80107015:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107016:	89 d3                	mov    %edx,%ebx
80107018:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010701e:	83 ec 1c             	sub    $0x1c,%esp
80107021:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107024:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107028:	8b 7d 08             	mov    0x8(%ebp),%edi
8010702b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107030:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107033:	8b 45 0c             	mov    0xc(%ebp),%eax
80107036:	29 df                	sub    %ebx,%edi
80107038:	83 c8 01             	or     $0x1,%eax
8010703b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010703e:	eb 15                	jmp    80107055 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107040:	f6 00 01             	testb  $0x1,(%eax)
80107043:	75 45                	jne    8010708a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107045:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107048:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010704b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010704d:	74 31                	je     80107080 <mappages+0x70>
      break;
    a += PGSIZE;
8010704f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107055:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107058:	b9 01 00 00 00       	mov    $0x1,%ecx
8010705d:	89 da                	mov    %ebx,%edx
8010705f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107062:	e8 29 ff ff ff       	call   80106f90 <walkpgdir>
80107067:	85 c0                	test   %eax,%eax
80107069:	75 d5                	jne    80107040 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
8010706b:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
8010706e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80107073:	5b                   	pop    %ebx
80107074:	5e                   	pop    %esi
80107075:	5f                   	pop    %edi
80107076:	5d                   	pop    %ebp
80107077:	c3                   	ret    
80107078:	90                   	nop
80107079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107080:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107083:	31 c0                	xor    %eax,%eax
}
80107085:	5b                   	pop    %ebx
80107086:	5e                   	pop    %esi
80107087:	5f                   	pop    %edi
80107088:	5d                   	pop    %ebp
80107089:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
8010708a:	83 ec 0c             	sub    $0xc,%esp
8010708d:	68 b4 83 10 80       	push   $0x801083b4
80107092:	e8 d9 92 ff ff       	call   80100370 <panic>
80107097:	89 f6                	mov    %esi,%esi
80107099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070a0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801070a0:	55                   	push   %ebp
801070a1:	89 e5                	mov    %esp,%ebp
801070a3:	57                   	push   %edi
801070a4:	56                   	push   %esi
801070a5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801070a6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801070ac:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801070ae:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801070b4:	83 ec 1c             	sub    $0x1c,%esp
801070b7:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801070ba:	39 d3                	cmp    %edx,%ebx
801070bc:	73 66                	jae    80107124 <deallocuvm.part.0+0x84>
801070be:	89 d6                	mov    %edx,%esi
801070c0:	eb 3d                	jmp    801070ff <deallocuvm.part.0+0x5f>
801070c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801070c8:	8b 10                	mov    (%eax),%edx
801070ca:	f6 c2 01             	test   $0x1,%dl
801070cd:	74 26                	je     801070f5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801070cf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801070d5:	74 58                	je     8010712f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801070d7:	83 ec 0c             	sub    $0xc,%esp
801070da:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801070e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801070e3:	52                   	push   %edx
801070e4:	e8 e7 b1 ff ff       	call   801022d0 <kfree>
      *pte = 0;
801070e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070ec:	83 c4 10             	add    $0x10,%esp
801070ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801070f5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801070fb:	39 f3                	cmp    %esi,%ebx
801070fd:	73 25                	jae    80107124 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
801070ff:	31 c9                	xor    %ecx,%ecx
80107101:	89 da                	mov    %ebx,%edx
80107103:	89 f8                	mov    %edi,%eax
80107105:	e8 86 fe ff ff       	call   80106f90 <walkpgdir>
    if(!pte)
8010710a:	85 c0                	test   %eax,%eax
8010710c:	75 ba                	jne    801070c8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010710e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107114:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010711a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107120:	39 f3                	cmp    %esi,%ebx
80107122:	72 db                	jb     801070ff <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107124:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107127:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010712a:	5b                   	pop    %ebx
8010712b:	5e                   	pop    %esi
8010712c:	5f                   	pop    %edi
8010712d:	5d                   	pop    %ebp
8010712e:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
8010712f:	83 ec 0c             	sub    $0xc,%esp
80107132:	68 86 7b 10 80       	push   $0x80107b86
80107137:	e8 34 92 ff ff       	call   80100370 <panic>
8010713c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107140 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107140:	55                   	push   %ebp
80107141:	89 e5                	mov    %esp,%ebp
80107143:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80107146:	e8 85 c6 ff ff       	call   801037d0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010714b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107151:	31 c9                	xor    %ecx,%ecx
80107153:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80107158:	66 89 90 d8 41 11 80 	mov    %dx,-0x7feebe28(%eax)
8010715f:	66 89 88 da 41 11 80 	mov    %cx,-0x7feebe26(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107166:	ba ff ff ff ff       	mov    $0xffffffff,%edx
8010716b:	31 c9                	xor    %ecx,%ecx
8010716d:	66 89 90 e0 41 11 80 	mov    %dx,-0x7feebe20(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107174:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107179:	66 89 88 e2 41 11 80 	mov    %cx,-0x7feebe1e(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107180:	31 c9                	xor    %ecx,%ecx
80107182:	66 89 90 e8 41 11 80 	mov    %dx,-0x7feebe18(%eax)
80107189:	66 89 88 ea 41 11 80 	mov    %cx,-0x7feebe16(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107190:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80107195:	31 c9                	xor    %ecx,%ecx
80107197:	66 89 90 f0 41 11 80 	mov    %dx,-0x7feebe10(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010719e:	c6 80 dc 41 11 80 00 	movb   $0x0,-0x7feebe24(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801071a5:	ba 2f 00 00 00       	mov    $0x2f,%edx
801071aa:	c6 80 dd 41 11 80 9a 	movb   $0x9a,-0x7feebe23(%eax)
801071b1:	c6 80 de 41 11 80 cf 	movb   $0xcf,-0x7feebe22(%eax)
801071b8:	c6 80 df 41 11 80 00 	movb   $0x0,-0x7feebe21(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801071bf:	c6 80 e4 41 11 80 00 	movb   $0x0,-0x7feebe1c(%eax)
801071c6:	c6 80 e5 41 11 80 92 	movb   $0x92,-0x7feebe1b(%eax)
801071cd:	c6 80 e6 41 11 80 cf 	movb   $0xcf,-0x7feebe1a(%eax)
801071d4:	c6 80 e7 41 11 80 00 	movb   $0x0,-0x7feebe19(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801071db:	c6 80 ec 41 11 80 00 	movb   $0x0,-0x7feebe14(%eax)
801071e2:	c6 80 ed 41 11 80 fa 	movb   $0xfa,-0x7feebe13(%eax)
801071e9:	c6 80 ee 41 11 80 cf 	movb   $0xcf,-0x7feebe12(%eax)
801071f0:	c6 80 ef 41 11 80 00 	movb   $0x0,-0x7feebe11(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801071f7:	66 89 88 f2 41 11 80 	mov    %cx,-0x7feebe0e(%eax)
801071fe:	c6 80 f4 41 11 80 00 	movb   $0x0,-0x7feebe0c(%eax)
80107205:	c6 80 f5 41 11 80 f2 	movb   $0xf2,-0x7feebe0b(%eax)
8010720c:	c6 80 f6 41 11 80 cf 	movb   $0xcf,-0x7feebe0a(%eax)
80107213:	c6 80 f7 41 11 80 00 	movb   $0x0,-0x7feebe09(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
8010721a:	05 d0 41 11 80       	add    $0x801141d0,%eax
8010721f:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80107223:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107227:	c1 e8 10             	shr    $0x10,%eax
8010722a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010722e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107231:	0f 01 10             	lgdtl  (%eax)
}
80107234:	c9                   	leave  
80107235:	c3                   	ret    
80107236:	8d 76 00             	lea    0x0(%esi),%esi
80107239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107240 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107240:	a1 84 76 11 80       	mov    0x80117684,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107245:	55                   	push   %ebp
80107246:	89 e5                	mov    %esp,%ebp
80107248:	05 00 00 00 80       	add    $0x80000000,%eax
8010724d:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80107250:	5d                   	pop    %ebp
80107251:	c3                   	ret    
80107252:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107260 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107260:	55                   	push   %ebp
80107261:	89 e5                	mov    %esp,%ebp
80107263:	57                   	push   %edi
80107264:	56                   	push   %esi
80107265:	53                   	push   %ebx
80107266:	83 ec 1c             	sub    $0x1c,%esp
80107269:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010726c:	85 f6                	test   %esi,%esi
8010726e:	0f 84 cd 00 00 00    	je     80107341 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80107274:	8b 46 08             	mov    0x8(%esi),%eax
80107277:	85 c0                	test   %eax,%eax
80107279:	0f 84 dc 00 00 00    	je     8010735b <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
8010727f:	8b 7e 04             	mov    0x4(%esi),%edi
80107282:	85 ff                	test   %edi,%edi
80107284:	0f 84 c4 00 00 00    	je     8010734e <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
8010728a:	e8 d1 d6 ff ff       	call   80104960 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010728f:	e8 bc c4 ff ff       	call   80103750 <mycpu>
80107294:	89 c3                	mov    %eax,%ebx
80107296:	e8 b5 c4 ff ff       	call   80103750 <mycpu>
8010729b:	89 c7                	mov    %eax,%edi
8010729d:	e8 ae c4 ff ff       	call   80103750 <mycpu>
801072a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801072a5:	83 c7 08             	add    $0x8,%edi
801072a8:	e8 a3 c4 ff ff       	call   80103750 <mycpu>
801072ad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801072b0:	83 c0 08             	add    $0x8,%eax
801072b3:	ba 67 00 00 00       	mov    $0x67,%edx
801072b8:	c1 e8 18             	shr    $0x18,%eax
801072bb:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
801072c2:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801072c9:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
801072d0:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
801072d7:	83 c1 08             	add    $0x8,%ecx
801072da:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801072e0:	c1 e9 10             	shr    $0x10,%ecx
801072e3:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801072e9:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
801072ee:	e8 5d c4 ff ff       	call   80103750 <mycpu>
801072f3:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801072fa:	e8 51 c4 ff ff       	call   80103750 <mycpu>
801072ff:	b9 10 00 00 00       	mov    $0x10,%ecx
80107304:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107308:	e8 43 c4 ff ff       	call   80103750 <mycpu>
8010730d:	8b 56 08             	mov    0x8(%esi),%edx
80107310:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80107316:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107319:	e8 32 c4 ff ff       	call   80103750 <mycpu>
8010731e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80107322:	b8 28 00 00 00       	mov    $0x28,%eax
80107327:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010732a:	8b 46 04             	mov    0x4(%esi),%eax
8010732d:	05 00 00 00 80       	add    $0x80000000,%eax
80107332:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80107335:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107338:	5b                   	pop    %ebx
80107339:	5e                   	pop    %esi
8010733a:	5f                   	pop    %edi
8010733b:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
8010733c:	e9 5f d6 ff ff       	jmp    801049a0 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80107341:	83 ec 0c             	sub    $0xc,%esp
80107344:	68 ba 83 10 80       	push   $0x801083ba
80107349:	e8 22 90 ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
8010734e:	83 ec 0c             	sub    $0xc,%esp
80107351:	68 e5 83 10 80       	push   $0x801083e5
80107356:	e8 15 90 ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
8010735b:	83 ec 0c             	sub    $0xc,%esp
8010735e:	68 d0 83 10 80       	push   $0x801083d0
80107363:	e8 08 90 ff ff       	call   80100370 <panic>
80107368:	90                   	nop
80107369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107370 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107370:	55                   	push   %ebp
80107371:	89 e5                	mov    %esp,%ebp
80107373:	57                   	push   %edi
80107374:	56                   	push   %esi
80107375:	53                   	push   %ebx
80107376:	83 ec 1c             	sub    $0x1c,%esp
80107379:	8b 75 10             	mov    0x10(%ebp),%esi
8010737c:	8b 45 08             	mov    0x8(%ebp),%eax
8010737f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80107382:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107388:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
8010738b:	77 49                	ja     801073d6 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
8010738d:	e8 ee b0 ff ff       	call   80102480 <kalloc>
  memset(mem, 0, PGSIZE);
80107392:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80107395:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107397:	68 00 10 00 00       	push   $0x1000
8010739c:	6a 00                	push   $0x0
8010739e:	50                   	push   %eax
8010739f:	e8 9c d7 ff ff       	call   80104b40 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801073a4:	58                   	pop    %eax
801073a5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801073ab:	b9 00 10 00 00       	mov    $0x1000,%ecx
801073b0:	5a                   	pop    %edx
801073b1:	6a 06                	push   $0x6
801073b3:	50                   	push   %eax
801073b4:	31 d2                	xor    %edx,%edx
801073b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801073b9:	e8 52 fc ff ff       	call   80107010 <mappages>
  memmove(mem, init, sz);
801073be:	89 75 10             	mov    %esi,0x10(%ebp)
801073c1:	89 7d 0c             	mov    %edi,0xc(%ebp)
801073c4:	83 c4 10             	add    $0x10,%esp
801073c7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801073ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073cd:	5b                   	pop    %ebx
801073ce:	5e                   	pop    %esi
801073cf:	5f                   	pop    %edi
801073d0:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
801073d1:	e9 1a d8 ff ff       	jmp    80104bf0 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
801073d6:	83 ec 0c             	sub    $0xc,%esp
801073d9:	68 f9 83 10 80       	push   $0x801083f9
801073de:	e8 8d 8f ff ff       	call   80100370 <panic>
801073e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801073e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073f0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801073f0:	55                   	push   %ebp
801073f1:	89 e5                	mov    %esp,%ebp
801073f3:	57                   	push   %edi
801073f4:	56                   	push   %esi
801073f5:	53                   	push   %ebx
801073f6:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801073f9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107400:	0f 85 91 00 00 00    	jne    80107497 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107406:	8b 75 18             	mov    0x18(%ebp),%esi
80107409:	31 db                	xor    %ebx,%ebx
8010740b:	85 f6                	test   %esi,%esi
8010740d:	75 1a                	jne    80107429 <loaduvm+0x39>
8010740f:	eb 6f                	jmp    80107480 <loaduvm+0x90>
80107411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107418:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010741e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107424:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107427:	76 57                	jbe    80107480 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107429:	8b 55 0c             	mov    0xc(%ebp),%edx
8010742c:	8b 45 08             	mov    0x8(%ebp),%eax
8010742f:	31 c9                	xor    %ecx,%ecx
80107431:	01 da                	add    %ebx,%edx
80107433:	e8 58 fb ff ff       	call   80106f90 <walkpgdir>
80107438:	85 c0                	test   %eax,%eax
8010743a:	74 4e                	je     8010748a <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
8010743c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010743e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80107441:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80107446:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010744b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107451:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107454:	01 d9                	add    %ebx,%ecx
80107456:	05 00 00 00 80       	add    $0x80000000,%eax
8010745b:	57                   	push   %edi
8010745c:	51                   	push   %ecx
8010745d:	50                   	push   %eax
8010745e:	ff 75 10             	pushl  0x10(%ebp)
80107461:	e8 da a4 ff ff       	call   80101940 <readi>
80107466:	83 c4 10             	add    $0x10,%esp
80107469:	39 c7                	cmp    %eax,%edi
8010746b:	74 ab                	je     80107418 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
8010746d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80107470:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80107475:	5b                   	pop    %ebx
80107476:	5e                   	pop    %esi
80107477:	5f                   	pop    %edi
80107478:	5d                   	pop    %ebp
80107479:	c3                   	ret    
8010747a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107480:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80107483:	31 c0                	xor    %eax,%eax
}
80107485:	5b                   	pop    %ebx
80107486:	5e                   	pop    %esi
80107487:	5f                   	pop    %edi
80107488:	5d                   	pop    %ebp
80107489:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
8010748a:	83 ec 0c             	sub    $0xc,%esp
8010748d:	68 13 84 10 80       	push   $0x80108413
80107492:	e8 d9 8e ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80107497:	83 ec 0c             	sub    $0xc,%esp
8010749a:	68 b4 84 10 80       	push   $0x801084b4
8010749f:	e8 cc 8e ff ff       	call   80100370 <panic>
801074a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801074aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801074b0 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801074b0:	55                   	push   %ebp
801074b1:	89 e5                	mov    %esp,%ebp
801074b3:	57                   	push   %edi
801074b4:	56                   	push   %esi
801074b5:	53                   	push   %ebx
801074b6:	83 ec 0c             	sub    $0xc,%esp
801074b9:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801074bc:	85 ff                	test   %edi,%edi
801074be:	0f 88 ca 00 00 00    	js     8010758e <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
801074c4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
801074c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
801074ca:	0f 82 82 00 00 00    	jb     80107552 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
801074d0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801074d6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
801074dc:	39 df                	cmp    %ebx,%edi
801074de:	77 43                	ja     80107523 <allocuvm+0x73>
801074e0:	e9 bb 00 00 00       	jmp    801075a0 <allocuvm+0xf0>
801074e5:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
801074e8:	83 ec 04             	sub    $0x4,%esp
801074eb:	68 00 10 00 00       	push   $0x1000
801074f0:	6a 00                	push   $0x0
801074f2:	50                   	push   %eax
801074f3:	e8 48 d6 ff ff       	call   80104b40 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801074f8:	58                   	pop    %eax
801074f9:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801074ff:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107504:	5a                   	pop    %edx
80107505:	6a 06                	push   $0x6
80107507:	50                   	push   %eax
80107508:	89 da                	mov    %ebx,%edx
8010750a:	8b 45 08             	mov    0x8(%ebp),%eax
8010750d:	e8 fe fa ff ff       	call   80107010 <mappages>
80107512:	83 c4 10             	add    $0x10,%esp
80107515:	85 c0                	test   %eax,%eax
80107517:	78 47                	js     80107560 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107519:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010751f:	39 df                	cmp    %ebx,%edi
80107521:	76 7d                	jbe    801075a0 <allocuvm+0xf0>
    mem = kalloc();
80107523:	e8 58 af ff ff       	call   80102480 <kalloc>
    if(mem == 0){
80107528:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
8010752a:	89 c6                	mov    %eax,%esi
    if(mem == 0){
8010752c:	75 ba                	jne    801074e8 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
8010752e:	83 ec 0c             	sub    $0xc,%esp
80107531:	68 31 84 10 80       	push   $0x80108431
80107536:	e8 25 91 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010753b:	83 c4 10             	add    $0x10,%esp
8010753e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107541:	76 4b                	jbe    8010758e <allocuvm+0xde>
80107543:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107546:	8b 45 08             	mov    0x8(%ebp),%eax
80107549:	89 fa                	mov    %edi,%edx
8010754b:	e8 50 fb ff ff       	call   801070a0 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80107550:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80107552:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107555:	5b                   	pop    %ebx
80107556:	5e                   	pop    %esi
80107557:	5f                   	pop    %edi
80107558:	5d                   	pop    %ebp
80107559:	c3                   	ret    
8010755a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80107560:	83 ec 0c             	sub    $0xc,%esp
80107563:	68 49 84 10 80       	push   $0x80108449
80107568:	e8 f3 90 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010756d:	83 c4 10             	add    $0x10,%esp
80107570:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107573:	76 0d                	jbe    80107582 <allocuvm+0xd2>
80107575:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107578:	8b 45 08             	mov    0x8(%ebp),%eax
8010757b:	89 fa                	mov    %edi,%edx
8010757d:	e8 1e fb ff ff       	call   801070a0 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80107582:	83 ec 0c             	sub    $0xc,%esp
80107585:	56                   	push   %esi
80107586:	e8 45 ad ff ff       	call   801022d0 <kfree>
      return 0;
8010758b:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
8010758e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80107591:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80107593:	5b                   	pop    %ebx
80107594:	5e                   	pop    %esi
80107595:	5f                   	pop    %edi
80107596:	5d                   	pop    %ebp
80107597:	c3                   	ret    
80107598:	90                   	nop
80107599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801075a3:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
801075a5:	5b                   	pop    %ebx
801075a6:	5e                   	pop    %esi
801075a7:	5f                   	pop    %edi
801075a8:	5d                   	pop    %ebp
801075a9:	c3                   	ret    
801075aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801075b0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801075b0:	55                   	push   %ebp
801075b1:	89 e5                	mov    %esp,%ebp
801075b3:	8b 55 0c             	mov    0xc(%ebp),%edx
801075b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801075b9:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801075bc:	39 d1                	cmp    %edx,%ecx
801075be:	73 10                	jae    801075d0 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801075c0:	5d                   	pop    %ebp
801075c1:	e9 da fa ff ff       	jmp    801070a0 <deallocuvm.part.0>
801075c6:	8d 76 00             	lea    0x0(%esi),%esi
801075c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801075d0:	89 d0                	mov    %edx,%eax
801075d2:	5d                   	pop    %ebp
801075d3:	c3                   	ret    
801075d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801075da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801075e0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801075e0:	55                   	push   %ebp
801075e1:	89 e5                	mov    %esp,%ebp
801075e3:	57                   	push   %edi
801075e4:	56                   	push   %esi
801075e5:	53                   	push   %ebx
801075e6:	83 ec 0c             	sub    $0xc,%esp
801075e9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801075ec:	85 f6                	test   %esi,%esi
801075ee:	74 59                	je     80107649 <freevm+0x69>
801075f0:	31 c9                	xor    %ecx,%ecx
801075f2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801075f7:	89 f0                	mov    %esi,%eax
801075f9:	e8 a2 fa ff ff       	call   801070a0 <deallocuvm.part.0>
801075fe:	89 f3                	mov    %esi,%ebx
80107600:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107606:	eb 0f                	jmp    80107617 <freevm+0x37>
80107608:	90                   	nop
80107609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107610:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107613:	39 fb                	cmp    %edi,%ebx
80107615:	74 23                	je     8010763a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107617:	8b 03                	mov    (%ebx),%eax
80107619:	a8 01                	test   $0x1,%al
8010761b:	74 f3                	je     80107610 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
8010761d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107622:	83 ec 0c             	sub    $0xc,%esp
80107625:	83 c3 04             	add    $0x4,%ebx
80107628:	05 00 00 00 80       	add    $0x80000000,%eax
8010762d:	50                   	push   %eax
8010762e:	e8 9d ac ff ff       	call   801022d0 <kfree>
80107633:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107636:	39 fb                	cmp    %edi,%ebx
80107638:	75 dd                	jne    80107617 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
8010763a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010763d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107640:	5b                   	pop    %ebx
80107641:	5e                   	pop    %esi
80107642:	5f                   	pop    %edi
80107643:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80107644:	e9 87 ac ff ff       	jmp    801022d0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80107649:	83 ec 0c             	sub    $0xc,%esp
8010764c:	68 65 84 10 80       	push   $0x80108465
80107651:	e8 1a 8d ff ff       	call   80100370 <panic>
80107656:	8d 76 00             	lea    0x0(%esi),%esi
80107659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107660 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107660:	55                   	push   %ebp
80107661:	89 e5                	mov    %esp,%ebp
80107663:	56                   	push   %esi
80107664:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107665:	e8 16 ae ff ff       	call   80102480 <kalloc>
8010766a:	85 c0                	test   %eax,%eax
8010766c:	74 6a                	je     801076d8 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
8010766e:	83 ec 04             	sub    $0x4,%esp
80107671:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107673:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80107678:	68 00 10 00 00       	push   $0x1000
8010767d:	6a 00                	push   $0x0
8010767f:	50                   	push   %eax
80107680:	e8 bb d4 ff ff       	call   80104b40 <memset>
80107685:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107688:	8b 43 04             	mov    0x4(%ebx),%eax
8010768b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010768e:	83 ec 08             	sub    $0x8,%esp
80107691:	8b 13                	mov    (%ebx),%edx
80107693:	ff 73 0c             	pushl  0xc(%ebx)
80107696:	50                   	push   %eax
80107697:	29 c1                	sub    %eax,%ecx
80107699:	89 f0                	mov    %esi,%eax
8010769b:	e8 70 f9 ff ff       	call   80107010 <mappages>
801076a0:	83 c4 10             	add    $0x10,%esp
801076a3:	85 c0                	test   %eax,%eax
801076a5:	78 19                	js     801076c0 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801076a7:	83 c3 10             	add    $0x10,%ebx
801076aa:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801076b0:	75 d6                	jne    80107688 <setupkvm+0x28>
801076b2:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
801076b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801076b7:	5b                   	pop    %ebx
801076b8:	5e                   	pop    %esi
801076b9:	5d                   	pop    %ebp
801076ba:	c3                   	ret    
801076bb:	90                   	nop
801076bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
801076c0:	83 ec 0c             	sub    $0xc,%esp
801076c3:	56                   	push   %esi
801076c4:	e8 17 ff ff ff       	call   801075e0 <freevm>
      return 0;
801076c9:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
801076cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
801076cf:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
801076d1:	5b                   	pop    %ebx
801076d2:	5e                   	pop    %esi
801076d3:	5d                   	pop    %ebp
801076d4:	c3                   	ret    
801076d5:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
801076d8:	31 c0                	xor    %eax,%eax
801076da:	eb d8                	jmp    801076b4 <setupkvm+0x54>
801076dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801076e0 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801076e0:	55                   	push   %ebp
801076e1:	89 e5                	mov    %esp,%ebp
801076e3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801076e6:	e8 75 ff ff ff       	call   80107660 <setupkvm>
801076eb:	a3 84 76 11 80       	mov    %eax,0x80117684
801076f0:	05 00 00 00 80       	add    $0x80000000,%eax
801076f5:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
801076f8:	c9                   	leave  
801076f9:	c3                   	ret    
801076fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107700 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107700:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107701:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107703:	89 e5                	mov    %esp,%ebp
80107705:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107708:	8b 55 0c             	mov    0xc(%ebp),%edx
8010770b:	8b 45 08             	mov    0x8(%ebp),%eax
8010770e:	e8 7d f8 ff ff       	call   80106f90 <walkpgdir>
  if(pte == 0)
80107713:	85 c0                	test   %eax,%eax
80107715:	74 05                	je     8010771c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107717:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010771a:	c9                   	leave  
8010771b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
8010771c:	83 ec 0c             	sub    $0xc,%esp
8010771f:	68 76 84 10 80       	push   $0x80108476
80107724:	e8 47 8c ff ff       	call   80100370 <panic>
80107729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107730 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107730:	55                   	push   %ebp
80107731:	89 e5                	mov    %esp,%ebp
80107733:	57                   	push   %edi
80107734:	56                   	push   %esi
80107735:	53                   	push   %ebx
80107736:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107739:	e8 22 ff ff ff       	call   80107660 <setupkvm>
8010773e:	85 c0                	test   %eax,%eax
80107740:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107743:	0f 84 c5 00 00 00    	je     8010780e <copyuvm+0xde>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107749:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010774c:	85 c9                	test   %ecx,%ecx
8010774e:	0f 84 9c 00 00 00    	je     801077f0 <copyuvm+0xc0>
80107754:	31 ff                	xor    %edi,%edi
80107756:	eb 4a                	jmp    801077a2 <copyuvm+0x72>
80107758:	90                   	nop
80107759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107760:	83 ec 04             	sub    $0x4,%esp
80107763:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107769:	68 00 10 00 00       	push   $0x1000
8010776e:	53                   	push   %ebx
8010776f:	50                   	push   %eax
80107770:	e8 7b d4 ff ff       	call   80104bf0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107775:	58                   	pop    %eax
80107776:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010777c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107781:	5a                   	pop    %edx
80107782:	ff 75 e4             	pushl  -0x1c(%ebp)
80107785:	50                   	push   %eax
80107786:	89 fa                	mov    %edi,%edx
80107788:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010778b:	e8 80 f8 ff ff       	call   80107010 <mappages>
80107790:	83 c4 10             	add    $0x10,%esp
80107793:	85 c0                	test   %eax,%eax
80107795:	78 69                	js     80107800 <copyuvm+0xd0>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107797:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010779d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
801077a0:	76 4e                	jbe    801077f0 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801077a2:	8b 45 08             	mov    0x8(%ebp),%eax
801077a5:	31 c9                	xor    %ecx,%ecx
801077a7:	89 fa                	mov    %edi,%edx
801077a9:	e8 e2 f7 ff ff       	call   80106f90 <walkpgdir>
801077ae:	85 c0                	test   %eax,%eax
801077b0:	74 6d                	je     8010781f <copyuvm+0xef>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
801077b2:	8b 00                	mov    (%eax),%eax
801077b4:	a8 01                	test   $0x1,%al
801077b6:	74 5a                	je     80107812 <copyuvm+0xe2>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801077b8:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
801077ba:	25 ff 0f 00 00       	and    $0xfff,%eax
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801077bf:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
801077c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801077c8:	e8 b3 ac ff ff       	call   80102480 <kalloc>
801077cd:	85 c0                	test   %eax,%eax
801077cf:	89 c6                	mov    %eax,%esi
801077d1:	75 8d                	jne    80107760 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801077d3:	83 ec 0c             	sub    $0xc,%esp
801077d6:	ff 75 e0             	pushl  -0x20(%ebp)
801077d9:	e8 02 fe ff ff       	call   801075e0 <freevm>
  return 0;
801077de:	83 c4 10             	add    $0x10,%esp
801077e1:	31 c0                	xor    %eax,%eax
}
801077e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077e6:	5b                   	pop    %ebx
801077e7:	5e                   	pop    %esi
801077e8:	5f                   	pop    %edi
801077e9:	5d                   	pop    %ebp
801077ea:	c3                   	ret    
801077eb:	90                   	nop
801077ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801077f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
801077f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077f6:	5b                   	pop    %ebx
801077f7:	5e                   	pop    %esi
801077f8:	5f                   	pop    %edi
801077f9:	5d                   	pop    %ebp
801077fa:	c3                   	ret    
801077fb:	90                   	nop
801077fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
      kfree(mem);
80107800:	83 ec 0c             	sub    $0xc,%esp
80107803:	56                   	push   %esi
80107804:	e8 c7 aa ff ff       	call   801022d0 <kfree>
      goto bad;
80107809:	83 c4 10             	add    $0x10,%esp
8010780c:	eb c5                	jmp    801077d3 <copyuvm+0xa3>
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
8010780e:	31 c0                	xor    %eax,%eax
80107810:	eb d1                	jmp    801077e3 <copyuvm+0xb3>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80107812:	83 ec 0c             	sub    $0xc,%esp
80107815:	68 9a 84 10 80       	push   $0x8010849a
8010781a:	e8 51 8b ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010781f:	83 ec 0c             	sub    $0xc,%esp
80107822:	68 80 84 10 80       	push   $0x80108480
80107827:	e8 44 8b ff ff       	call   80100370 <panic>
8010782c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107830 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107830:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107831:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107833:	89 e5                	mov    %esp,%ebp
80107835:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107838:	8b 55 0c             	mov    0xc(%ebp),%edx
8010783b:	8b 45 08             	mov    0x8(%ebp),%eax
8010783e:	e8 4d f7 ff ff       	call   80106f90 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107843:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80107845:	89 c2                	mov    %eax,%edx
80107847:	83 e2 05             	and    $0x5,%edx
8010784a:	83 fa 05             	cmp    $0x5,%edx
8010784d:	75 11                	jne    80107860 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
8010784f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80107854:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80107855:	05 00 00 00 80       	add    $0x80000000,%eax
}
8010785a:	c3                   	ret    
8010785b:	90                   	nop
8010785c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80107860:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80107862:	c9                   	leave  
80107863:	c3                   	ret    
80107864:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010786a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107870 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107870:	55                   	push   %ebp
80107871:	89 e5                	mov    %esp,%ebp
80107873:	57                   	push   %edi
80107874:	56                   	push   %esi
80107875:	53                   	push   %ebx
80107876:	83 ec 1c             	sub    $0x1c,%esp
80107879:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010787c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010787f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107882:	85 db                	test   %ebx,%ebx
80107884:	75 40                	jne    801078c6 <copyout+0x56>
80107886:	eb 70                	jmp    801078f8 <copyout+0x88>
80107888:	90                   	nop
80107889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107890:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107893:	89 f1                	mov    %esi,%ecx
80107895:	29 d1                	sub    %edx,%ecx
80107897:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010789d:	39 d9                	cmp    %ebx,%ecx
8010789f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801078a2:	29 f2                	sub    %esi,%edx
801078a4:	83 ec 04             	sub    $0x4,%esp
801078a7:	01 d0                	add    %edx,%eax
801078a9:	51                   	push   %ecx
801078aa:	57                   	push   %edi
801078ab:	50                   	push   %eax
801078ac:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801078af:	e8 3c d3 ff ff       	call   80104bf0 <memmove>
    len -= n;
    buf += n;
801078b4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801078b7:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
801078ba:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
801078c0:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801078c2:	29 cb                	sub    %ecx,%ebx
801078c4:	74 32                	je     801078f8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
801078c6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801078c8:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
801078cb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801078ce:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801078d4:	56                   	push   %esi
801078d5:	ff 75 08             	pushl  0x8(%ebp)
801078d8:	e8 53 ff ff ff       	call   80107830 <uva2ka>
    if(pa0 == 0)
801078dd:	83 c4 10             	add    $0x10,%esp
801078e0:	85 c0                	test   %eax,%eax
801078e2:	75 ac                	jne    80107890 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
801078e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
801078e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
801078ec:	5b                   	pop    %ebx
801078ed:	5e                   	pop    %esi
801078ee:	5f                   	pop    %edi
801078ef:	5d                   	pop    %ebp
801078f0:	c3                   	ret    
801078f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
801078fb:	31 c0                	xor    %eax,%eax
}
801078fd:	5b                   	pop    %ebx
801078fe:	5e                   	pop    %esi
801078ff:	5f                   	pop    %edi
80107900:	5d                   	pop    %ebp
80107901:	c3                   	ret    
