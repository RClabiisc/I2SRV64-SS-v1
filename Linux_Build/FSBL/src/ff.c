

#include "ff.h"         /* Declarations of FatFs API */
#include "diskio.h"     /* Declarations of disk I/O functions */
#include "uart.h"


#if _FATFS != 64180 /* Revision ID */
#error Wrong include file (ff.h).
#endif


/* Reentrancy related */

#define ENTER_FF(fs)
#define LEAVE_FF(fs, res)   return res


#define ABORT(fs, res)      { fp->err = (uint8_t)(res); LEAVE_FF(fs, res); }


/* Definitions of sector size */
#if (_MAX_SS < _MIN_SS) || (_MAX_SS != 512 && _MAX_SS != 1024 && _MAX_SS != 2048 && _MAX_SS != 4096) || (_MIN_SS != 512 && _MIN_SS != 1024 && _MIN_SS != 2048 && _MIN_SS != 4096)
#error Wrong sector size configuration
#endif
#if _MAX_SS == _MIN_SS
#define SS(fs)  ((uint32_t)_MAX_SS) /* Fixed sector size */
#else
#define SS(fs)  ((fs)->ssize)   /* Variable sector size */
#endif


/* Timestamp feature */
#if _FS_NORTC == 1
#if _NORTC_YEAR < 1980 || _NORTC_YEAR > 2107 || _NORTC_MON < 1 || _NORTC_MON > 12 || _NORTC_MDAY < 1 || _NORTC_MDAY > 31
#error Invalid _FS_NORTC settings
#endif
#define GET_FATTIME()   ((uint32_t)(_NORTC_YEAR - 1980) << 25 | (uint32_t)_NORTC_MON << 21 | (uint32_t)_NORTC_MDAY << 16)
#else
#define GET_FATTIME()   get_fattime()
#endif






#define _DF1S   0




  /* Character code support macros */
#define IsUpper(c)  (((c)>='A')&&((c)<='Z'))
#define IsLower(c)  (((c)>='a')&&((c)<='z'))
#define IsDigit(c)  (((c)>='0')&&((c)<='9'))

#if _DF1S       /* Code page is DBCS */

#ifdef _DF2S    /* Two 1st byte areas */
#define IsDBCS1(c)  (((uint8_t)(c) >= _DF1S && (uint8_t)(c) <= _DF1E) || ((uint8_t)(c) >= _DF2S && (uint8_t)(c) <= _DF2E))
#else           /* One 1st byte area */
#define IsDBCS1(c)  ((uint8_t)(c) >= _DF1S && (uint8_t)(c) <= _DF1E)
#endif

#ifdef _DS3S    /* Three 2nd byte areas */
#define IsDBCS2(c)  (((uint8_t)(c) >= _DS1S && (uint8_t)(c) <= _DS1E) || ((uint8_t)(c) >= _DS2S && (uint8_t)(c) <= _DS2E) || ((uint8_t)(c) >= _DS3S && (uint8_t)(c) <= _DS3E))
#else           /* Two 2nd byte areas */
#define IsDBCS2(c)  (((uint8_t)(c) >= _DS1S && (uint8_t)(c) <= _DS1E) || ((uint8_t)(c) >= _DS2S && (uint8_t)(c) <= _DS2E))
#endif

#else           /* Code page is SBCS */

#define IsDBCS1(c)  0
#define IsDBCS2(c)  0

#endif /* _DF1S */


  /* Name status flags */
#define NSFLAG      11      /* Index of name status byte in fn[] */
#define NS_LOSS     0x01    /* Out of 8.3 format */
#define NS_LFN      0x02    /* Force to create LFN entry */
#define NS_LAST     0x04    /* Last segment */
#define NS_BODY     0x08    /* Lower case flag (body) */
#define NS_EXT      0x10    /* Lower case flag (ext) */
#define NS_DOT      0x20    /* Dot entry */


  /* FAT sub-type boundaries (Differ from specs but correct for real DOS/Windows) */
#define MIN_FAT16   4086U   /* Minimum number of clusters of FAT16 */
#define MIN_FAT32   65526U  /* Minimum number of clusters of FAT32 */


  /* FatFs refers the members in the FAT structures as byte array instead of
     / structure members because the structure is not binary compatible between
     / different platforms */

#define BS_jmpBoot          0       /* x86 jump instruction (3) */
#define BS_OEMName          3       /* OEM name (8) */
#define BPB_BytsPerSec      11      /* Sector size [byte] (2) */
#define BPB_SecPerClus      13      /* Cluster size [sector] (1) */
#define BPB_RsvdSecCnt      14      /* Size of reserved area [sector] (2) */
#define BPB_NumFATs         16      /* Number of FAT copies (1) */
#define BPB_RootEntCnt      17      /* Number of root directory entries for FAT12/16 (2) */
#define BPB_TotSec16        19      /* Volume size [sector] (2) */
#define BPB_Media           21      /* Media descriptor (1) */
#define BPB_FATSz16         22      /* FAT size [sector] (2) */
#define BPB_SecPerTrk       24      /* Track size [sector] (2) */
#define BPB_NumHeads        26      /* Number of heads (2) */
#define BPB_HiddSec         28      /* Number of special hidden sectors (4) */
#define BPB_TotSec32        32      /* Volume size [sector] (4) */
#define BS_DrvNum           36      /* Physical drive number (1) */
#define BS_NTres            37      /* Error flag (1) */
#define BS_BootSig          38      /* Extended boot signature (1) */
#define BS_VolID            39      /* Volume serial number (4) */
#define BS_VolLab           43      /* Volume label (8) */
#define BS_FilSysType       54      /* File system type (1) */
#define BPB_FATSz32         36      /* FAT size [sector] (4) */
#define BPB_ExtFlags        40      /* Extended flags (2) */
#define BPB_FSVer           42      /* File system version (2) */
#define BPB_RootClus        44      /* Root directory first cluster (4) */
#define BPB_FSInfo          48      /* Offset of FSINFO sector (2) */
#define BPB_BkBootSec       50      /* Offset of backup boot sector (2) */
#define BS_DrvNum32         64      /* Physical drive number (1) */
#define BS_NTres32          65      /* Error flag (1) */
#define BS_BootSig32        66      /* Extended boot signature (1) */
#define BS_VolID32          67      /* Volume serial number (4) */
#define BS_VolLab32         71      /* Volume label (8) */
#define BS_FilSysType32     82      /* File system type (1) */
#define FSI_LeadSig         0       /* FSI: Leading signature (4) */
#define FSI_StrucSig        484     /* FSI: Structure signature (4) */
#define FSI_Free_Count      488     /* FSI: Number of free clusters (4) */
#define FSI_Nxt_Free        492     /* FSI: Last allocated cluster (4) */
#define MBR_Table           446     /* MBR: Partition table offset (2) */
#define SZ_PTE              16      /* MBR: Size of a partition table entry */
#define BS_55AA             510     /* Signature word (2) */

#define DIR_Name            0       /* Short file name (11) */
#define DIR_Attr            11      /* Attribute (1) */
#define DIR_NTres           12      /* Lower case flag (1) */
#define DIR_CrtTimeTenth    13      /* Created time sub-second (1) */
#define DIR_CrtTime         14      /* Created time (2) */
#define DIR_CrtDate         16      /* Created date (2) */
#define DIR_LstAccDate      18      /* Last accessed date (2) */
#define DIR_FstClusHI       20      /* Higher 16-bit of first cluster (2) */
#define DIR_WrtTime         22      /* Modified time (2) */
#define DIR_WrtDate         24      /* Modified date (2) */
#define DIR_FstClusLO       26      /* Lower 16-bit of first cluster (2) */
#define DIR_FileSize        28      /* File size (4) */
#define LDIR_Ord            0       /* LFN entry order and LLE flag (1) */
#define LDIR_Attr           11      /* LFN attribute (1) */
#define LDIR_Type           12      /* LFN type (1) */
#define LDIR_Chksum         13      /* Checksum of corresponding SFN entry */
#define LDIR_FstClusLO      26      /* Must be zero (0) */
#define SZ_DIRE             32      /* Size of a directory entry */
#define LLEF                0x40    /* Last long entry flag in LDIR_Ord */
#define DDEM                0xE5    /* Deleted directory entry mark at DIR_Name[0] */
#define RDDEM               0x05    /* Replacement of the character collides with DDEM */




/*--------------------------------------------------------------------------

  Module Private Work Area

  ---------------------------------------------------------------------------*/

/* Remark: Uninitialized variables with static duration are guaranteed
 *  zero/null at start-up. If not, either the linker or start-up routine
 *  being used is not compliance with ANSI-C standard.
 */

#if _VOLUMES < 1 || _VOLUMES > 9
#error Wrong _VOLUMES setting
#endif
static FATFS *FatFs[_VOLUMES];  /* Pointer to the file system objects (logical drives) */
static uint16_t Fsid;               /* File system mount ID */





#if _USE_LFN == 0           /* Non LFN feature */
#define DEFINE_NAMEBUF      uint8_t sfn[12]
#define INIT_BUF(dobj)      (dobj).fn = sfn
#define FREE_BUF()
#else
#if _MAX_LFN < 12 || _MAX_LFN > 255
#error Wrong _MAX_LFN setting
#endif

#if _USE_LFN == 1           /* LFN feature with static working buffer */
static uint16_t LfnBuf[_MAX_LFN + 1];
#define DEFINE_NAMEBUF      uint8_t sfn[12]
#define INIT_BUF(dobj)      { (dobj).fn = sfn; (dobj).lfn = LfnBuf; }
#define FREE_BUF()
#elif _USE_LFN == 2         /* LFN feature with dynamic working buffer on the stack */
#define DEFINE_NAMEBUF      uint8_t sfn[12]; uint16_t lbuf[_MAX_LFN + 1]
#define INIT_BUF(dobj)      { (dobj).fn = sfn; (dobj).lfn = lbuf; }
#define FREE_BUF()
#elif _USE_LFN == 3         /* LFN feature with dynamic working buffer on the heap */
#define DEFINE_NAMEBUF      uint8_t sfn[12]; uint16_t *lfn
#define INIT_BUF(dobj)      { lfn = ff_memalloc((_MAX_LFN + 1) * 2); if (!lfn) LEAVE_FF((dobj).fs, FR_NOT_ENOUGH_CORE); (dobj).lfn = lfn; (dobj).fn = sfn; }
#define FREE_BUF()          ff_memfree(lfn)
#else
#error Wrong _USE_LFN setting
#endif
#endif

#ifdef _EXCVT
static const uint8_t ExCvt[] = _EXCVT; /* Upper conversion table for SBCS extended characters */
#endif







/*-----------------------------------------------------------------------*/
/* String functions                                                      */
/*-----------------------------------------------------------------------*/

/* Copy memory to memory */
static
void mem_cpy (void* dst, const void* src, uint32_t cnt) {
  uint8_t *d = (uint8_t*)dst;
  const uint8_t *s = (const uint8_t*)src;


  while (cnt--)
    *d++ = *s++;
}

/* Fill memory */
static
void mem_set (void* dst, int val, uint32_t cnt) {
  uint8_t *d = (uint8_t*)dst;

  while (cnt--)
    *d++ = (uint8_t)val;
}

/* Compare memory to memory */
static
int mem_cmp (const void* dst, const void* src, uint32_t cnt) {
  const uint8_t *d = (const uint8_t *)dst, *s = (const uint8_t *)src;
  int r = 0;

  while (cnt-- && (r = *d++ - *s++) == 0) ;
  return r;
}

/* Check if chr is contained in the string */
static
int chk_chr (const char* str, int chr) {
  while (*str && *str != chr) str++;
  return *str;
}



static FRESULT move_window (   /* FR_OK(0):succeeded, !=0:error */
                     FATFS* fs,        /* File system object */
                     uint32_t sector   /* Sector number to make appearance in the fs->win[] */
                        )
{
  FRESULT res = FR_OK;

//   printf("[MOVE_WINDOW]we will look into sector %d \n\r", sector);
  if (sector != fs->winsect) {  /* Window offset changed? */


    
    if (res == FR_OK) {         /* Fill sector window with new data */
      if (disk_read(fs->drv, fs->win, sector, 1) != RES_OK) {
        sector = 0xFFFFFFFF;    /* Invalidate window if data is not reliable */
        res = FR_DISK_ERR;
        // printf("[MOVE_WINDOW]disk read reply with bad number, so failed\n\r", 0 );
      }
      fs->winsect = sector;
    }
  }
  // printf("[MOVE_WINDOW]finished with res %d \n\r", res);
  return res;
}









/*-----------------------------------------------------------------------*/
/* Get sector# from cluster#                                             */
/*-----------------------------------------------------------------------*/
/* Hidden API for hacks and disk tools */

uint32_t clust2sect (  /* !=0:Sector number, 0:Failed (invalid cluster#) */
                     FATFS* fs,           /* File system object */
                     uint32_t clst        /* Cluster# to be converted */
                       )
{
  clst -= 2;
  if (clst >= fs->n_fatent - 2) return 0;       /* Invalid cluster# */
  return clst * fs->csize + fs->database;
}




/*-----------------------------------------------------------------------*/
/* FAT access - Read value of a FAT entry                                */
/*-----------------------------------------------------------------------*/
/* Hidden API for hacks and disk tools */

uint32_t get_fat ( /* 0xFFFFFFFF:Disk error, 1:Internal error, 2..0x0FFFFFFF:Cluster status */
                  FATFS* fs,      /* File system object */
                  uint32_t clst   /* FAT index number (cluster number) to get the value */
                   )
{
  uint32_t wc, bc;
  uint8_t *p;
  uint32_t val;


  if (clst < 2 || clst >= fs->n_fatent) {   /* Check if in valid range */
    val = 1;    /* Internal error */

  } else {
    val = 0xFFFFFFFF;   /* Default value falls on disk error */

    switch (fs->fs_type) {
    case FS_FAT12 :
      bc = (uint32_t)clst; bc += bc / 2;
      if (move_window(fs, fs->fatbase + (bc / SS(fs))) != FR_OK) break;
      wc = fs->win[bc++ % SS(fs)];
      if (move_window(fs, fs->fatbase + (bc / SS(fs))) != FR_OK) break;
      wc |= fs->win[bc % SS(fs)] << 8;
      val = clst & 1 ? wc >> 4 : (wc & 0xFFF);
      break;

    case FS_FAT16 :
      if (move_window(fs, fs->fatbase + (clst / (SS(fs) / 2))) != FR_OK) break;
      p = &fs->win[clst * 2 % SS(fs)];
      val = LD_WORD(p);
      break;

    case FS_FAT32 :
      if (move_window(fs, fs->fatbase + (clst / (SS(fs) / 4))) != FR_OK) break;
      p = &fs->win[clst * 4 % SS(fs)];
      val = LD_DWORD(p) & 0x0FFFFFFF;
      break;

    default:
      val = 1;  /* Internal error */
    }
  }

  return val;
}

/*-----------------------------------------------------------------------*/
/* Directory handling - Set directory index                              */
/*-----------------------------------------------------------------------*/

static
FRESULT dir_sdi (   /* FR_OK(0):succeeded, !=0:error */
                 DIR* dp,           /* Pointer to directory object */
                 uint32_t idx       /* Index of directory table */
                    )
{
  uint32_t clst, sect;
  uint32_t ic;


  dp->index = (uint16_t)idx;    /* Current index */
  clst = dp->sclust;            /* Table start cluster (0:root) */
  if (clst == 1 || clst >= dp->fs->n_fatent)    /* Check start cluster range */
    return FR_INT_ERR;
  if (!clst && dp->fs->fs_type == FS_FAT32) /* Replace cluster# 0 with root cluster# if in FAT32 */
    clst = dp->fs->dirbase;

  if (clst == 0) {  /* Static table (root-directory in FAT12/16) */
    if (idx >= dp->fs->n_rootdir)   /* Is index out of range? */
      return FR_INT_ERR;
    sect = dp->fs->dirbase;
  }
  else {                /* Dynamic table (root-directory in FAT32 or sub-directory) */
    ic = SS(dp->fs) / SZ_DIRE * dp->fs->csize;  /* Entries per cluster */
    while (idx >= ic) { /* Follow cluster chain */
      clst = get_fat(dp->fs, clst);             /* Get next cluster */
      if (clst == 0xFFFFFFFF) return FR_DISK_ERR;   /* Disk error */
      if (clst < 2 || clst >= dp->fs->n_fatent) /* Reached to end of table or internal error */
        return FR_INT_ERR;
      idx -= ic;
    }
    sect = clust2sect(dp->fs, clst);
  }
  dp->clust = clst; /* Current cluster# */
  if (!sect) return FR_INT_ERR;
  dp->sect = sect + idx / (SS(dp->fs) / SZ_DIRE);                   /* Sector# of the directory entry */
  dp->dir = dp->fs->win + (idx % (SS(dp->fs) / SZ_DIRE)) * SZ_DIRE; /* Ptr to the entry in the sector */

  return FR_OK;
}




/*-----------------------------------------------------------------------*/
/* Directory handling - Move directory table index next                  */
/*-----------------------------------------------------------------------*/

static
FRESULT dir_next (  /* FR_OK(0):succeeded, FR_NO_FILE:End of table, FR_DENIED:Could not stretch */
                  DIR* dp,          /* Pointer to the directory object */
                  int stretch       /* 0: Do not stretch table, 1: Stretch table if needed */
                    )
{
  uint32_t clst;
  uint32_t i;



  i = dp->index + 1;
  if (!(i & 0xFFFF) || !dp->sect)   /* Report EOT when index has reached 65535 */
    return FR_NO_FILE;

  if (!(i % (SS(dp->fs) / SZ_DIRE))) {  /* Sector changed? */
    dp->sect++;                 /* Next sector */

    if (!dp->clust) {       /* Static table */
      if (i >= dp->fs->n_rootdir)   /* Report EOT if it reached end of static table */
        return FR_NO_FILE;
    }
    else {                  /* Dynamic table */
      if (((i / (SS(dp->fs) / SZ_DIRE)) & (dp->fs->csize - 1)) == 0) {  /* Cluster changed? */
        clst = get_fat(dp->fs, dp->clust);              /* Get next cluster */
        if (clst <= 1) return FR_INT_ERR;
        if (clst == 0xFFFFFFFF) return FR_DISK_ERR;
        if (clst >= dp->fs->n_fatent) {                 /* If it reached end of dynamic table, */

          if (!stretch) return FR_NO_FILE;          /* If do not stretch, report EOT (this is to suppress warning) */
          return FR_NO_FILE;                            /* Report EOT */

        }
        dp->clust = clst;               /* Initialize data for new cluster */
        dp->sect = clust2sect(dp->fs, clst);
      }
    }
  }

  dp->index = (uint16_t)i;  /* Current index */
  dp->dir = dp->fs->win + (i % (SS(dp->fs) / SZ_DIRE)) * SZ_DIRE;   /* Current entry in the window */

  return FR_OK;
}







/*-----------------------------------------------------------------------*/
/* Directory handling - Load/Store start cluster number                  */
/*-----------------------------------------------------------------------*/

static
uint32_t ld_clust (    /* Returns the top cluster value of the SFN entry */
                   FATFS* fs,         /* Pointer to the fs object */
                   const uint8_t* dir /* Pointer to the SFN entry */
                       )
{
  uint32_t cl;

  cl = LD_WORD(dir + DIR_FstClusLO);
  if (fs->fs_type == FS_FAT32)
    cl |= (uint32_t)LD_WORD(dir + DIR_FstClusHI) << 16;

  return cl;
}


/*-----------------------------------------------------------------------*/
/* Directory handling - Find an object in the directory                  */
/*-----------------------------------------------------------------------*/

static
FRESULT dir_find (  /* FR_OK(0):succeeded, !=0:error */
                  DIR* dp           /* Pointer to the directory object linked to the file name */
                    )
{
  FRESULT res;
  uint8_t c, *dir;


  res = dir_sdi(dp, 0);         /* Rewind directory object */
  if (res != FR_OK) return res;


  do {
    res = move_window(dp->fs, dp->sect);
    if (res != FR_OK) break;
    dir = dp->dir;                  /* Ptr to the directory entry of current index */
    c = dir[DIR_Name];
    if (c == 0) { res = FR_NO_FILE; break; }    /* Reached to end of table */
      /* Non LFN configuration */
    if (!(dir[DIR_Attr] & AM_VOL) && !mem_cmp(dir, dp->fn, 11)) /* Is it a valid entry? */
      break;

    res = dir_next(dp, 0);      /* Next entry */
  } while (res == FR_OK);

  return res;
}



/*-----------------------------------------------------------------------*/
/* Pick a top segment and create the object name in directory form       */
/*-----------------------------------------------------------------------*/

static
FRESULT create_name (   /* FR_OK: successful, FR_INVALID_NAME: could not create */
                     DIR* dp,           /* Pointer to the directory object */
                     const TCHAR** path /* Pointer to pointer to the segment in the path string */
                        )
{

  /* Non-LFN configuration */
  uint8_t b, c, d, *sfn;
  uint32_t ni, si, i;
  const char *p;

  /* Create file name in directory form */
  for (p = *path; *p == '/' || *p == '\\'; p++) ;   /* Skip duplicated separator */
  sfn = dp->fn;
  mem_set(sfn, ' ', 11);
  si = i = b = 0; ni = 8;

  for (;;) {
    c = (uint8_t)p[si++];
    if (c <= ' ' || c == '/' || c == '\\') break;   /* Break on end of segment */
    if (c == '.' || i >= ni) {
      if (ni != 8 || c != '.') return FR_INVALID_NAME;
      i = 8; ni = 11;
      b <<= 2; continue;
    }
    if (c >= 0x80) {                /* Extended character? */
      b |= 3;                       /* Eliminate NT flag */
#ifdef _EXCVT
      c = ExCvt[c - 0x80];          /* To upper extended characters (SBCS cfg) */
#else
#if !_DF1S
      return FR_INVALID_NAME;       /* Reject extended characters (ASCII cfg) */
#endif
#endif
    }
    if (IsDBCS1(c)) {               /* Check if it is a DBC 1st byte (always false at SBCS cfg.) */
      d = (uint8_t)p[si++];            /* Get 2nd byte */
      if (!IsDBCS2(d) || i >= ni - 1)   /* Reject invalid DBC */
        return FR_INVALID_NAME;
      sfn[i++] = c;
      sfn[i++] = d;
    } else {                        /* SBC */
      if (chk_chr("\"*+,:;<=>\?[]|\x7F", c))    /* Reject illegal chrs for SFN */
        return FR_INVALID_NAME;
      if (IsUpper(c)) {         /* ASCII large capital? */
        b |= 2;
      } else {
        if (IsLower(c)) {       /* ASCII small capital? */
          b |= 1; c -= 0x20;
        }
      }
      sfn[i++] = c;
    }
  }
  *path = &p[si];                       /* Return pointer to the next segment */
  c = (c <= ' ') ? NS_LAST : 0;         /* Set last segment flag if end of path */

  if (!i) return FR_INVALID_NAME;       /* Reject nul string */
  if (sfn[0] == DDEM) sfn[0] = RDDEM;   /* When first character collides with DDEM, replace it with RDDEM */

  if (ni == 8) b <<= 2;
  if ((b & 0x03) == 0x01) c |= NS_EXT;  /* NT flag (Name extension has only small capital) */
  if ((b & 0x0C) == 0x04) c |= NS_BODY; /* NT flag (Name body has only small capital) */

  sfn[NSFLAG] = c;      /* Store NT flag, File name is created */

  return FR_OK;

}




/*-----------------------------------------------------------------------*/
/* Follow a file path                                                    */
/*-----------------------------------------------------------------------*/

static
FRESULT follow_path (   /* FR_OK(0): successful, !=0: error code */
                     DIR* dp,           /* Directory object to return last directory and found object */
                     const TCHAR* path  /* Full-path string to find a file or directory */
                        )
{
  FRESULT res;
  uint8_t *dir, ns;


  if (*path == '/' || *path == '\\')    /* Strip heading separator if exist */
    path++;
  dp->sclust = 0;                       /* Always start from the root directory */


  if ((uint32_t)*path < ' ') {          /* Null path name is the origin directory itself */
    res = dir_sdi(dp, 0);
    dp->dir = 0;
  } else {                              /* Follow path */
    for (;;) {
      res = create_name(dp, &path); /* Get a segment name of the path */
      if (res != FR_OK) break;
      res = dir_find(dp);               /* Find an object with the sagment name */
      ns = dp->fn[NSFLAG];
      if (res != FR_OK) {               /* Failed to find the object */
        if (res == FR_NO_FILE) {    /* Object is not found */
          if (_FS_RPATH && (ns & NS_DOT)) { /* If dot entry is not exist, */
            dp->sclust = 0; dp->dir = 0;    /* it is the root directory and stay there */
            if (!(ns & NS_LAST)) continue;  /* Continue to follow if not last segment */
            res = FR_OK;                    /* Ended at the root directroy. Function completed. */
          } else {                          /* Could not find the object */
            if (!(ns & NS_LAST)) res = FR_NO_PATH;  /* Adjust error code if not last segment */
          }
        }
        break;
      }
      if (ns & NS_LAST) break;          /* Last segment matched. Function completed. */
      dir = dp->dir;                    /* Follow the sub-directory */
      if (!(dir[DIR_Attr] & AM_DIR)) {  /* It is not a sub-directory and cannot follow */
        res = FR_NO_PATH; break;
      }
      dp->sclust = ld_clust(dp->fs, dir);
    }
  }

  return res;
}




/*-----------------------------------------------------------------------*/
/* Get logical drive number from path name                               */
/*-----------------------------------------------------------------------*/

static
int get_ldnumber (      /* Returns logical drive number (-1:invalid drive) */
                  const TCHAR** path    /* Pointer to pointer to the path name */
                        )
{
  const TCHAR *tp, *tt;
  uint32_t i;
  int vol = -1;



  if (*path) {  /* If the pointer is not a null */
    for (tt = *path; (uint32_t)*tt >= (_USE_LFN ? ' ' : '!') && *tt != ':'; tt++) ; /* Find ':' in the path */
    if (*tt == ':') {   /* If a ':' is exist in the path name */
      tp = *path;
      i = *tp++ - '0'; 
      if (i < 10 && tp == tt) { /* Is there a numeric drive id? */
        if (i < _VOLUMES) { /* If a drive id is found, get the value and strip it */
          vol = (int)i;
          *path = ++tt;
        }
      }

      return vol;
    }

    vol = 0;        /* Drive 0 */

  }
  return vol;
}




/*-----------------------------------------------------------------------*/
/* Load a sector and check if it is an FAT boot sector                   */
/*-----------------------------------------------------------------------*/

static
uint8_t check_fs ( /* 0:Valid FAT-BS, 1:Valid BS but not FAT, 2:Not a BS, 3:Disk error */
                  FATFS* fs,      /* File system object */
                  uint32_t sect   /* Sector# (lba) to check if it is an FAT boot record or not */
                   )
{
  fs->wflag = 0; fs->winsect = 0xFFFFFFFF;  /* Invaidate window */
  if (move_window(fs, sect) != FR_OK)       /* Load boot record */
    return 3;

  if (LD_WORD(&fs->win[BS_55AA]) != 0xAA55) /* Check boot record signature (always placed at offset 510 even if the sector size is >512) */
    return 2;

  if ((LD_DWORD(&fs->win[BS_FilSysType]) & 0xFFFFFF) == 0x544146)       /* Check "FAT" string */
    return 0;
  if ((LD_DWORD(&fs->win[BS_FilSysType32]) & 0xFFFFFF) == 0x544146) /* Check "FAT" string */
    return 0;

  return 1;
}




/*-----------------------------------------------------------------------*/
/* Find logical drive and check if the volume is mounted                 */
/*-----------------------------------------------------------------------*/

static
FRESULT find_volume (   /* FR_OK(0): successful, !=0: any error occurred */
                     FATFS** rfs,           /* Pointer to pointer to the found file system object */
                     const TCHAR** path,    /* Pointer to pointer to the path name (drive number) */
                     uint8_t wmode          /* !=0: Check write protection for write access */
                        )
{
  uint8_t fmt, *pt;
  int vol;
  DSTATUS stat;
  uint32_t bsect, fasize, tsect, sysect, nclst, szbfat, br[4];
  uint16_t nrsv;
  FATFS *fs;
  uint32_t i;
  
  // printf("[FIND_VOLUME]find volume starts \n\r", 0);


  /* Get logical drive number from the path name */
  *rfs = 0;
  vol = get_ldnumber(path);
  if (vol < 0) return FR_INVALID_DRIVE;

  /* Check if the file system object is valid or not */
  fs = FatFs[vol];                      /* Get pointer to the file system object */
  if (!fs) return FR_NOT_ENABLED;       /* Is the file system object available? */

  ENTER_FF(fs);                         /* Lock the volume */
  *rfs = fs;                            /* Return pointer to the file system object */

  if (fs->fs_type) {                    /* If the volume has been mounted */
    stat = disk_status(fs->drv);
    if (!(stat & STA_NOINIT)) {     /* and the physical drive is kept initialized */
      if (!_FS_READONLY && wmode && (stat & STA_PROTECT))   /* Check write protection if needed */
        return FR_WRITE_PROTECTED;
      return FR_OK;             /* The file system object is valid */
    }
  }

  /* The file system object is not valid. */
  /* Following code attempts to mount the volume. (analyze BPB and initialize the fs object) */

  fs->fs_type = 0;                  /* Clear the file system object */
  fs->drv = LD2PD(vol);             /* Bind the logical drive and a physical drive */
  stat = disk_initialize(fs->drv);  /* Initialize the physical drive */
  
  printf("    - disk_initialization try  \n\r", 0);
  
  if (stat & STA_NOINIT)                /* Check if the initialization succeeded */
    return FR_NOT_READY;            /* Failed to initialize due to no medium or hard error */
    
    
    printf("    - disk_initialization done \n\r", 0);
    
  if (!_FS_READONLY && wmode && (stat & STA_PROTECT))   /* Check disk write protection if needed */
    return FR_WRITE_PROTECTED;
    
    printf("    - FR_WRITE_PROTECTED \n\r", 0);

  /* Find an FAT partition on the drive. Supports only generic partitioning, FDISK and SFD. */
  bsect = 0;
  // printf("    - checking the sector %d \n\r", bsect);
  fmt = check_fs(fs, bsect);                    /* Load sector 0 and check if it is an FAT boot sector as SFD */
 //  printf("    - result of check_fs res %d  \n\r", fmt);
  if (fmt == 1 || (!fmt && (LD2PT(vol)))) { /* Not an FAT boot sector or forced partition number */
    for (i = 0; i < 4; i++) {           /* Get partition offset */
      pt = fs->win + MBR_Table + i * SZ_PTE;
      br[i] = pt[4] ? LD_DWORD(&pt[8]) : 0;
    }
    i = LD2PT(vol);                     /* Partition number: 0:auto, 1-4:forced */
    if (i) i--;
    do {                                /* Find an FAT volume */
     
      bsect = br[i];
    
      fmt = bsect ? check_fs(fs, bsect) : 2;    /* Check the partition */

    } while (!LD2PT(vol) && fmt && ++i < 4);
  }
  if (fmt == 3) return FR_DISK_ERR;     /* An error occured in the disk I/O layer */
  if (fmt) return FR_NO_FILESYSTEM;     /* No FAT volume is found */
   
  /* An FAT volume is found. Following code initializes the file system object */
   printf("    - FAT volume found \n\r", 0);
  if (LD_WORD(fs->win + BPB_BytsPerSec) != SS(fs))  /* (BPB_BytsPerSec must be equal to the physical sector size) */
    return FR_NO_FILESYSTEM;

  fasize = LD_WORD(fs->win + BPB_FATSz16);          /* Number of sectors per FAT */
  if (!fasize) fasize = LD_DWORD(fs->win + BPB_FATSz32);
  fs->fsize = fasize;

  fs->n_fats = fs->win[BPB_NumFATs];                    /* Number of FAT copies */
  if (fs->n_fats != 1 && fs->n_fats != 2)               /* (Must be 1 or 2) */
    return FR_NO_FILESYSTEM;
  fasize *= fs->n_fats;                             /* Number of sectors for FAT area */

  fs->csize = fs->win[BPB_SecPerClus];              /* Number of sectors per cluster */
  if (!fs->csize || (fs->csize & (fs->csize - 1)))  /* (Must be power of 2) */
    return FR_NO_FILESYSTEM;

  fs->n_rootdir = LD_WORD(fs->win + BPB_RootEntCnt);    /* Number of root directory entries */
  if (fs->n_rootdir % (SS(fs) / SZ_DIRE))               /* (Must be sector aligned) */
    return FR_NO_FILESYSTEM;

  tsect = LD_WORD(fs->win + BPB_TotSec16);          /* Number of sectors on the volume */
  if (!tsect) tsect = LD_DWORD(fs->win + BPB_TotSec32);

  nrsv = LD_WORD(fs->win + BPB_RsvdSecCnt);         /* Number of reserved sectors */
  if (!nrsv) return FR_NO_FILESYSTEM;                   /* (Must not be 0) */

  /* Determine the FAT sub type */
  sysect = nrsv + fasize + fs->n_rootdir / (SS(fs) / SZ_DIRE);  /* RSV + FAT + DIR */
  if (tsect < sysect) return FR_NO_FILESYSTEM;      /* (Invalid volume size) */
  nclst = (tsect - sysect) / fs->csize;             /* Number of clusters */
  if (!nclst) return FR_NO_FILESYSTEM;              /* (Invalid volume size) */
  fmt = FS_FAT12;
  if (nclst >= MIN_FAT16) fmt = FS_FAT16;
  if (nclst >= MIN_FAT32) fmt = FS_FAT32;

  /* Boundaries and Limits */
  fs->n_fatent = nclst + 2;                         /* Number of FAT entries */
  fs->volbase = bsect;                              /* Volume start sector */
  fs->fatbase = bsect + nrsv;                       /* FAT start sector */
  fs->database = bsect + sysect;                        /* Data start sector */
  if (fmt == FS_FAT32) {
    if (fs->n_rootdir) return FR_NO_FILESYSTEM;     /* (BPB_RootEntCnt must be 0) */
    fs->dirbase = LD_DWORD(fs->win + BPB_RootClus); /* Root directory start cluster */
    szbfat = fs->n_fatent * 4;                      /* (Needed FAT size) */
  } else {
    if (!fs->n_rootdir) return FR_NO_FILESYSTEM;    /* (BPB_RootEntCnt must not be 0) */
    fs->dirbase = fs->fatbase + fasize;             /* Root directory start sector */
    szbfat = (fmt == FS_FAT16) ?                    /* (Needed FAT size) */
      fs->n_fatent * 2 : fs->n_fatent * 3 / 2 + (fs->n_fatent & 1);
  }
  if (fs->fsize < (szbfat + (SS(fs) - 1)) / SS(fs)) /* (BPB_FATSz must not be less than the size needed) */
    return FR_NO_FILESYSTEM;


  fs->fs_type = fmt;    /* FAT sub-type */
  fs->id = ++Fsid;  /* File system mount ID */


 //  printf("[FIND_VOLUME] find_volume succeeded\n\r", 0);

  return FR_OK;
}




/*-----------------------------------------------------------------------*/
/* Check if the file/directory object is valid or not                    */
/*-----------------------------------------------------------------------*/

static
FRESULT validate (  /* FR_OK(0): The object is valid, !=0: Invalid */
                  void* obj     /* Pointer to the object FIL/DIR to check validity */
                    )
{
  FIL *fil = (FIL*)obj; /* Assuming offset of .fs and .id in the FIL/DIR structure is identical */


  if (!fil || !fil->fs || !fil->fs->fs_type || fil->fs->id != fil->id || (disk_status(fil->fs->drv) & STA_NOINIT))
    return FR_INVALID_OBJECT;

  ENTER_FF(fil->fs);        /* Lock file system */

  return FR_OK;
}




/*-----------------------------------------------------------------------*/
/* Mount/Unmount a Logical Drive                                         */
/*-----------------------------------------------------------------------*/

FRESULT f_mount (
                 FATFS* fs,         /* Pointer to the file system object (NULL:unmount)*/
                 const TCHAR* path, /* Logical drive number to be mounted/unmounted */
                 uint8_t opt           /* 0:Do not mount (delayed mount), 1:Mount immediately */
                 )
{
  FATFS *cfs;
  int vol;
  FRESULT res;
  const TCHAR *rp = path;


  vol = get_ldnumber(&rp);
  if (vol < 0) return FR_INVALID_DRIVE;

  cfs = FatFs[vol];                 /* Pointer to fs object */

  if (cfs) {




    
    cfs->fs_type = 0;               /* Clear old fs object */
  }

  if (fs) {
    fs->fs_type = 0;                /* Clear new fs object */



  }

  FatFs[vol] = fs;                  /* Register new fs object */

  if (!fs || opt != 1) return FR_OK;    /* Do not mount now, it will be mounted later */

  res = find_volume(&fs, &path, 0); /* Force mounted the volume */
  


  LEAVE_FF(fs, res);

}




/*-----------------------------------------------------------------------*/
/* Open or Create a File                                                 */
/*-----------------------------------------------------------------------*/

FRESULT f_open (
                FIL* fp,            /* Pointer to the blank file object */
                const TCHAR* path,  /* Pointer to the file name */
                uint8_t mode           /* Access mode and file open mode flags */
                )
{
  FRESULT res;
  DIR dj;
  uint8_t *dir;
  DEFINE_NAMEBUF;



  if (!fp) return FR_INVALID_OBJECT;
  fp->fs = 0;           /* Clear file object */

  /* Get logical drive number */

  mode &= FA_READ;
  res = find_volume(&dj.fs, &path, 0);

  if (res == FR_OK) {
    INIT_BUF(dj);
    res = follow_path(&dj, path);   /* Follow the file path */
    dir = dj.dir;

     /* R/O configuration */
    if (res == FR_OK) {                 /* Follow succeeded */
      dir = dj.dir;
      if (!dir) {                       /* Current directory itself */
        res = FR_INVALID_NAME;
      } else {
        if (dir[DIR_Attr] & AM_DIR) /* It is a directory */
          res = FR_NO_FILE;
      }
    }

    FREE_BUF();

    if (res == FR_OK) {
      fp->flag = mode;                  /* File access mode */
      fp->err = 0;                      /* Clear error flag */
      fp->sclust = ld_clust(dj.fs, dir);    /* File start cluster */
      fp->fsize = LD_DWORD(dir + DIR_FileSize); /* File size */
      fp->fptr = 0;                     /* File pointer */
      fp->dsect = 0;
      fp->fs = dj.fs;                       /* Validate file object */
      fp->id = fp->fs->id;
    }
  }

  LEAVE_FF(dj.fs, res);
}




/*-----------------------------------------------------------------------*/
/* Read File                                                             */
/*-----------------------------------------------------------------------*/

FRESULT f_read (
                FIL* fp,        /* Pointer to the file object */
                void* buff,     /* Pointer to data buffer */
                uint32_t btr,       /* Number of bytes to read */
                uint32_t* br        /* Pointer to number of bytes read */
                )
{
  FRESULT res;
  uint32_t clst, sect, remain;
  uint32_t rcnt, cc;
  uint8_t csect, *rbuff = (uint8_t*)buff;


  *br = 0;  /* Clear read byte counter */

  res = validate(fp);                           /* Check validity */
  if (res != FR_OK) LEAVE_FF(fp->fs, res);
  if (fp->err)                              /* Check error */
    LEAVE_FF(fp->fs, (FRESULT)fp->err);
  if (!(fp->flag & FA_READ))                    /* Check access mode */
    LEAVE_FF(fp->fs, FR_DENIED);
  remain = fp->fsize - fp->fptr;
  if (btr > remain) btr = (uint32_t)remain;     /* Truncate btr by remaining bytes */

  for ( ;  btr;                             /* Repeat until all data read */
        rbuff += rcnt, fp->fptr += rcnt, *br += rcnt, btr -= rcnt) {
    if ((fp->fptr % SS(fp->fs)) == 0) {     /* On the sector boundary? */
      csect = (uint8_t)(fp->fptr / SS(fp->fs) & (fp->fs->csize - 1));  /* Sector offset in the cluster */
      if (!csect) {                     /* On the cluster boundary? */
        if (fp->fptr == 0) {            /* On the top of the file? */
          clst = fp->sclust;            /* Follow from the origin */
        } else {                        /* Middle or end of the file */

            clst = get_fat(fp->fs, fp->clust);  /* Follow cluster chain on the FAT */
        }
        if (clst < 2) ABORT(fp->fs, FR_INT_ERR);
        if (clst == 0xFFFFFFFF) ABORT(fp->fs, FR_DISK_ERR);
        fp->clust = clst;               /* Update current cluster */
      }
      sect = clust2sect(fp->fs, fp->clust); /* Get current sector */
      if (!sect) ABORT(fp->fs, FR_INT_ERR);
      sect += csect;
      cc = btr / SS(fp->fs);                /* When remaining bytes >= sector size, */
   //   printf("disk_read_start\n\r",0);
      if (cc) {                         /* Read maximum contiguous sectors directly */
        if (csect + cc > fp->fs->csize) /* Clip at cluster boundary */
          cc = fp->fs->csize - csect;
        if (disk_read(fp->fs->drv, rbuff, sect, cc) != RES_OK){
          ABORT(fp->fs, FR_DISK_ERR);
          printf("disk_read_response ABORT\n\r",0);
          }
        //  printf("disk_read_response_OK\n\r",0);

        rcnt = SS(fp->fs) * cc;         /* Number of bytes transferred */
        continue;
      }
    //  printf("disk_read_finished\n\r",0);
#if !_FS_TINY
      if (fp->dsect != sect) {          /* Load data sector if not in cache */
       //  printf("disk_read again call\n\r",0);
        if (disk_read(fp->fs->drv, fp->buf, sect, 1) != RES_OK) /* Fill sector cache */
          ABORT(fp->fs, FR_DISK_ERR);
      }
#endif
      fp->dsect = sect;
    }
    rcnt = SS(fp->fs) - ((uint32_t)fp->fptr % SS(fp->fs));  /* Get partial sector data from sector buffer */
    if (rcnt > btr) rcnt = btr;

    mem_cpy(rbuff, &fp->buf[fp->fptr % SS(fp->fs)], rcnt);  /* Pick partial sector */

  }

  LEAVE_FF(fp->fs, FR_OK);
}





