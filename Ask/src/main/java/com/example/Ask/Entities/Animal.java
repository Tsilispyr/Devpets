package com.example.Ask.Entities;
import jakarta.persistence.*;
import com.example.Ask.Entities.Gender;

@Entity
@Table
public class Animal {



    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column
    private Integer id;

    @Column
    private int req;
    @Column
    private int age;
    @Enumerated(EnumType.STRING)
    private Gender Gender;
    @Column
    private String type;

    @Column
    private String name;

    @Column
    private Integer userId;

    public String getName() {
        return name;
    }

    public Integer getId() {
        return id;
    }

    public int getAge() {
        return age;
    }

    public Gender getGender() {
        return Gender;
    }

    public String getType() {
        return type;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getReq() {
        return req;
    }
    public void setName(String name) {
        this.name = name;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public void setType(String type) {
        this.type = type;
    }

    public void setGender(Gender gender) {
        this.Gender = gender;
    }

    public void setReq(Integer req) { this.req = req; }

    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }

    public Animal(Integer id, int age, Gender gender, String type, String name) {
        this.id = id;
        this.age = age;
        this.Gender = gender;
        this.type = type;
        this.name = name;
    }
    public Animal() {

    }


}
