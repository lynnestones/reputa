import { describe, it, expect, beforeEach } from "vitest"

const mockContract = {
  admin: "ST1ADMIN",
  scores: new Map<string, number>(),
  endorsements: new Map<string, number>(),
  disputes: new Map<string, number>(),

  isAdmin(caller: string) {
    return caller === this.admin
  },

  getScore(user: string) {
    return this.scores.get(user) ?? 500
  },

  initializeUser(caller: string, user: string) {
    if (!this.isAdmin(caller)) return { error: 100 }
    this.scores.set(user, 500)
    return { value: true }
  },

  endorse(caller: string, target: string, weight: number) {
    if (caller === target) return { error: 101 }
    const key = `${caller}|${target}`
    if (this.endorsements.has(key)) return { error: 102 }
    this.endorsements.set(key, weight)
    const current = this.getScore(target)
    this.scores.set(target, Math.min(1000, current + weight))
    return { value: true }
  },

  revokeEndorsement(caller: string, target: string) {
    const key = `${caller}|${target}`
    if (!this.endorsements.has(key)) return { error: 103 }
    const weight = this.endorsements.get(key)!
    this.endorsements.delete(key)
    const current = this.getScore(target)
    this.scores.set(target, Math.max(0, current - weight))
    return { value: true }
  },

  strike(caller: string, user: string, penalty: number) {
    if (!this.isAdmin(caller)) return { error: 100 }
    const total = (this.disputes.get(user) ?? 0) + penalty
    this.disputes.set(user, total)
    const current = this.getScore(user)
    this.scores.set(user, Math.max(0, current - penalty))
    return { value: true }
  },

  transferAdmin(caller: string, newAdmin: string) {
    if (!this.isAdmin(caller)) return { error: 100 }
    this.admin = newAdmin
    return { value: true }
  },
}

describe("Reputa Reputation Score Contract", () => {
  beforeEach(() => {
    mockContract.admin = "ST1ADMIN"
    mockContract.scores = new Map()
    mockContract.endorsements = new Map()
    mockContract.disputes = new Map()
  })

  it("initializes a user", () => {
    const result = mockContract.initializeUser("ST1ADMIN", "ST2USER")
    expect(result).toEqual({ value: true })
    expect(mockContract.getScore("ST2USER")).toBe(500)
  })

  it("adds an endorsement", () => {
    mockContract.initializeUser("ST1ADMIN", "ST2USER")
    const result = mockContract.endorse("ST3ENDORSE", "ST2USER", 50)
    expect(result).toEqual({ value: true })
    expect(mockContract.getScore("ST2USER")).toBe(550)
  })

  it("prevents self-endorsement", () => {
    const result = mockContract.endorse("ST2USER", "ST2USER", 10)
    expect(result).toEqual({ error: 101 })
  })

  it("revokes an endorsement", () => {
    mockContract.endorse("ST3ENDORSE", "ST2USER", 30)
    const result = mockContract.revokeEndorsement("ST3ENDORSE", "ST2USER")
    expect(result).toEqual({ value: true })
    expect(mockContract.getScore("ST2USER")).toBe(500)
  })

  it("strikes a user", () => {
    mockContract.initializeUser("ST1ADMIN", "ST4BAD")
    const result = mockContract.strike("ST1ADMIN", "ST4BAD", 70)
    expect(result).toEqual({ value: true })
    expect(mockContract.getScore("ST4BAD")).toBe(430)
  })

  it("transfers admin rights", () => {
    const result = mockContract.transferAdmin("ST1ADMIN", "ST2NEWADMIN")
    expect(result).toEqual({ value: true })
    expect(mockContract.admin).toBe("ST2NEWADMIN")
  })
})
