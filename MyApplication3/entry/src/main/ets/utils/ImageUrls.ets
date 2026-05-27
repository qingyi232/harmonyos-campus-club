/**
 * 远程占位图（需 ohos.permission.INTERNET）
 * 使用 picsum 按 seed 固定图片，避免列表里每张都一样
 */
export class ImageUrls {
  static clubCover(seed: string): string {
    const s: string = seed.replace(/[^a-zA-Z0-9]/g, 'x');
    return `https://picsum.photos/seed/${s}c/400/280`;
  }

  static activityCover(seed: string): string {
    const s: string = seed.replace(/[^a-zA-Z0-9]/g, 'x');
    return `https://picsum.photos/seed/${s}a/360/240`;
  }

  static userFace(seed: string): string {
    const s: string = seed.replace(/[^a-zA-Z0-9]/g, 'x');
    return `https://picsum.photos/seed/${s}u/200/200`;
  }
}
