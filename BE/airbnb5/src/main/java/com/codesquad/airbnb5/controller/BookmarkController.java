package com.codesquad.airbnb5.controller;

import com.codesquad.airbnb5.dao.RoomMapper;
import com.codesquad.airbnb5.dto.ResponseDTO;
import com.codesquad.airbnb5.service.BookmarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.sql.SQLException;

@RequestMapping("/bookmarks")
@RestController
public class BookmarkController {

    @Autowired
    private RoomMapper roomMapper;

    @Autowired
    private BookmarkService bookmarkService;

    @PostMapping("/{roomId}")
    public ResponseEntity<ResponseDTO> addBookmark(
            @PathVariable("roomId") int roomId,
            @RequestAttribute("guestId") int guestId) {
        ResponseDTO responseDto = bookmarkService.addFavoriteStatus(roomId, guestId);
        return ResponseEntity.ok().body(responseDto);
    }

    @DeleteMapping("/{roomId}")
    public ResponseEntity<ResponseDTO> deleteBookmark(
            @PathVariable("roomId") int roomId,
            @RequestAttribute("guestId") int guestId) {
        ResponseDTO responseDto = bookmarkService.deleteFavoriteStatus(roomId, guestId);
        return ResponseEntity.ok().body(responseDto);
    }

    @GetMapping("")
    public ResponseEntity<ResponseDTO> getBookmarks(
            @RequestAttribute("guestId") int guestId) throws SQLException {
        ResponseDTO responseDto = bookmarkService.getBookmarkList(guestId, roomMapper);
        return ResponseEntity.ok().body(responseDto);
    }
}
